import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/account_share.service.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/config/settings.dart';
import 'package:api_dox/constants/limits.dart';
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
  /// Profile fields are refreshed from the token. Then make sure the user
  /// has a group and has joined every group and wallet that invited their
  /// email.
  Future<User> findOrCreate(FirebaseIdentity identity) async {
    User? user = await users.findByFirebaseUid(identity.uid);
    if (user != null && await groups.hasGroup(user)) {
      return _setUp(user, identity);
    }

    // First sign-in (no user, or a user with no group yet). The web app
    // sends a few requests at once, and each isolate would create the user
    // (a unique-index 500) and its own personal group. So this part runs
    // one at a time.
    // ponytail: file lock, one host only. Several hosts need a DB lock.
    CacheLock lock = Cache().lock(
      'first-sign-in:${identity.uid}',
      firstSignInLockTtl,
    );
    bool locked = await _take(lock);
    try {
      // Another request may have made the user while this one waited.
      user = await users.findByFirebaseUid(identity.uid);
      user ??= await users.create(
        firebaseUid: identity.uid,
        email: identity.email ?? '',
        displayName: identity.name,
        photoUrl: identity.picture,
      );
      return await _setUp(user, identity);
    } finally {
      if (locked) await lock.release();
    }
  }

  /// Wait for [lock]. False when the cache does not work (read-only disk):
  /// then sign-in goes on without it, as before.
  static Future<bool> _take(CacheLock lock) async {
    try {
      return await lock.block(firstSignInLockTtl);
    } catch (error) {
      Logger.warn('[auth] first sign-in lock failed: $error');
      return false;
    }
  }

  Future<User> _setUp(User user, FirebaseIdentity identity) async {
    String email = identity.email ?? '';
    if (user.email != email ||
        user.displayName != identity.name ||
        user.photoUrl != identity.picture) {
      user = await users.update(user.id!, <String, dynamic>{
        'email': email,
        'display_name': identity.name,
        'photo_url': identity.picture,
      });
    }
    await groups.claimPendingInvitations(user);
    await accountShares.claimPendingInvitations(user);
    await groups.ensurePersonalGroup(user);
    return user;
  }
}
