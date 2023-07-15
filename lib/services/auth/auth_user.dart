import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
  // A factory constructor gives more flexibility to create an object.
  // Generative constructors only create an instance of the class.
  // But, the factory constructor can return an instance of the class or even subclass.
  // It is also used to return the cached instance of the class.
}     
 