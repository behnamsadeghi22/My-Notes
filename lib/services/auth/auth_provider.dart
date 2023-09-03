import 'package:notes/services/auth/auth_user.dart';

// abstract classes are used as a base class for other classes.
// a class is a blueprint for creating objects that have properties and methods,
// whereas an abstract class is a class that cannot be instantiated directly,
// but can be used as a base class for other classes.
abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
