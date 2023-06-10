// login exceptions
class userNotFoundAuthException implements Exception {
}
class WrongPasswordAuthException implements Exception {
}
//register exceptions
class WeakPasswordAuthException implements Exception {

}
class EmailAlreadyInUseAuthException implements Exception {

}
class InvalidEmailAuthException implements Exception {

}
//generic exceptions
class GenericAuthException implements Exception {

}
class UserNotVerifiedAuthException implements Exception {

}
class UserNotLoggedInAuthException implements Exception {

}