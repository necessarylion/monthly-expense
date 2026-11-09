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

  /// Firebase uid -> the user and when the entry ends. Each isolate has its
  /// own. It skips the sign-in queries for a user seen a moment ago.
  // ponytail: grows by one entry per user; fine for a small user count.
  final Map<String, (User, DateTime)> _recent = <String, (User, DateTime)>{};

  /// True when ALLOWED_EMAILS is empty or lists this email.
  bool isEmailAllowed(String? email) {
    List<String> allowed = settings.allowedEmails;
    return allowed.isEmpty || allowed.contains((email ?? '').toLowerCase());
  }

  /// Find the user by Firebase UID, or create them on first sign-in.
  /// Profile fields are refreshed from the token. Then make sure the user
  /// has a group and has joined every group and wallet that invited their
  /// email. A user seen in the last [authUserCacheTtl] skips all of this,
  /// so a new invite can show up that much later.
  Future<User> findOrCreate(FirebaseIdentity identity) async {
    User? cached = _cached(identity);
    if (cached != null) return cached;
    User user = await _findOrCreate(identity);
    _recent[identity.uid] = (user, DateTime.now().add(authUserCacheTtl));
    return user;
  }

  /// The cached user, or null when there is none, it is old, or the token
  /// has a new name, email or photo (the full path saves those).
  User? _cached(FirebaseIdentity identity) {
    (User, DateTime)? entry = _recent[identity.uid];
    if (entry == null || entry.$2.isBefore(DateTime.now())) return null;
    if (!_sameProfile(entry.$1, identity)) return null;
    return entry.$1;
  }

  static bool _sameProfile(User user, FirebaseIdentity identity) {
    return user.email == (identity.email ?? '') &&
        user.displayName == identity.name &&
        user.photoUrl == identity.picture;
  }

  Future<User> _findOrCreate(FirebaseIdentity identity) async {
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
    if (!_sameProfile(user, identity)) {
      user = await users.update(user.id!, <String, dynamic>{
        'email': identity.email ?? '',
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
