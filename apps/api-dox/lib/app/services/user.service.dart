import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/account_share.service.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/config/settings.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
class UserService {
  UserService(this.users, this.groups, this.accountShares, this.settings);

  final UserRepository users;
  final GroupService groups;
  final AccountShareService accountShares;
  final AppSettings settings;

  /// True when ALLOWED_EMAILS is empty or lists this email.
  bool isEmailAllowed(String? email) {
    List<String> allowed = settings.allowedEmails;
    return allowed.isEmpty || allowed.contains((email ?? '').toLowerCase());
  }

  /// Find the user by Firebase UID, or create them on first sign-in.
  /// A known user costs one query. Invites are claimed only when the user
  /// is new or their email changed: an invite to an email that already has
  /// a user joins at once (see `invite()`), so nothing else can be pending.
  /// A user with no group gets one from `GroupService.listForUser`.
  Future<User> findOrCreate(FirebaseIdentity identity) async {
    User? user = await users.findByFirebaseUid(identity.uid);
    if (user == null) return _firstSignIn(identity);
    if (_sameProfile(user, identity)) return user;
    bool emailChanged = user.email != _email(identity);
    user = await users.update(user.id!, <String, dynamic>{
      'email': _email(identity),
      'display_name': identity.name,
      'photo_url': identity.picture,
    });
    if (emailChanged) await _claimInvitations(user);
    return user;
  }

  /// The web app sends a few requests at once, and each isolate would
  /// create the user (a unique-index 500) and its own personal group. So
  /// this runs one at a time, under the lock `listForUser` waits on.
  Future<User> _firstSignIn(FirebaseIdentity identity) async {
    CacheLock lock = GroupService.signInLock(identity.uid);
    bool locked = await GroupService.takeLock(lock);
    try {
      // Another request may have made the user while this one waited.
      User? user = await users.findByFirebaseUid(identity.uid);
      if (user != null) return user;
      user = await users.create(
        firebaseUid: identity.uid,
        email: _email(identity),
        displayName: identity.name,
        photoUrl: identity.picture,
      );
      await _claimInvitations(user);
      await groups.ensurePersonalGroup(user);
      return user;
    } finally {
      if (locked) await lock.release();
    }
  }

  Future<void> _claimInvitations(User user) async {
    await groups.claimPendingInvitations(user);
    await accountShares.claimPendingInvitations(user);
  }

  /// Saved lowercase, so `invite()` finds the user by email.
  static String _email(FirebaseIdentity identity) {
    return GroupService.normalizeEmail(identity.email ?? '');
  }

  static bool _sameProfile(User user, FirebaseIdentity identity) {
    return user.email == _email(identity) &&
        user.displayName == identity.name &&
        user.photoUrl == identity.picture;
  }
}
