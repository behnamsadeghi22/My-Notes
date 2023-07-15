// login exceptions
// The class 'UserNotFoundAuthExceotion' can't extend 'Exception' because 'Exception' only has factory constructors (no generative constructors), and 'UserNotFoundAuthExceotion' has at least one generative constructor.
// Try implementing the class instead, adding a generative (not factory) constructor to the superclass 'Exception', or a factory constructor to the subclass.
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailmAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
