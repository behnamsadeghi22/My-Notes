import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:notes/services/auth/firebase_auth_provider.dart';

class AuthSrvice implements AuthProvider {
  final AuthProvider provider;
  const AuthSrvice(this.provider);

  // AuthService provides a factory for FIREBASE , but it's not making an assumption about that : Heyyy..I'm always locked to FIREBASE , this is dependency injection
  factory AuthSrvice.firebase() => AuthSrvice(FirebaseAuthProvider());
  // We get access to our FirebaseAuthProvider() inside AuthSrvice , it's really magical
  // factory AuthSrvice.apple() => AuthSrvice(AppleAuthProvider());  : Example for Apple Authentication instead Firebase
  // The factory constructor is named firebase,
  // which means that it can be used to create instances of the
  // AuthSrvice class using the syntax AuthSrvice.firebase()
 
  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
