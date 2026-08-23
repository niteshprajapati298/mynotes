import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test('Should not be intialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot Logout if Not intialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('Shoulb be able to be intialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null after intialization', () {
      expect(provider.currentUser, null);
    });
    test(
      'Should be able initialize less then 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'test@123',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final badPasswordUser = provider.createUser(
        email: 'abc@abc.com',
        password: "foobar",
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );
      final user = await provider.createUser(
        email: "nitesh@gmail.com",
        password: 'Kajal@298',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('send email verfication should verify the user', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> reloadUser() {
    // TODO: implement reloadUser
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
