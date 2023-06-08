import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/services.dart' show PlatformException;

/// The [AuthError] class represents authentication errors.
Map<String, AuthError> authErrorMapping = {
  'email-already-exists': const AuthErrorEmailAlreadyExists(),
  'id-token-expired': const AuthErrorTokenExpired(),
  'id-token-revoked': const AuthErrorTokenRevoked(),
  'invalid-email': const AuthErrorInvalidEmail(),
  'operation-not-allowed': const AuthErrorOperationNotAllowed(),
  'user-not-found': const AuthErrorUserNotFound(),
  'requires-recent-login': const AuthErrorRequiresRecentLogin(),
  'weak-password': const AuthErrorWeakPassword(),
  'user-mismatch': const AuthErrorUserMismatch(),
  'wrong-password': const AuthErrorWrongPassword(),
  'email-already-in-use': const AuthErrorEmailAlreadyExists(),
  'too-many-requests': const AuthErrorTooManyRequests(),
  'Exception: invalid-social-network': const AuthErrorOperationNotAllowed(),
  'network_error': AuthErrorNetworkError(),
  'network-request-failed': AuthErrorNetworkError(),
};

@immutable
sealed class AuthError extends Equatable {
  /// The title of the error dialog to be displayed.
  final String dialogTitle;

  /// The text of the error dialog to be displayed.
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  /// Factory method to create an [AuthError] object based on a [Exception].
  /// [exception] - The [Exception] from which to create the [AuthError].
  /// Returns an [AuthError] object corresponding to the provided exception,
  /// or a default [AuthErrorUnknown] object if no mapping is found.

  factory AuthError.from(Exception exception) {
    if (exception is FirebaseAuthException) {
      return authErrorMapping[exception.code.toLowerCase().trim()] ??
          const AuthErrorUnknown();
    }

    if (exception is PlatformException) {
      String errorMessage = exception.code;
      return authErrorMapping[errorMessage] ?? const AuthErrorUnknown();
    }

    String errorMessage = exception.toString();
    return authErrorMapping[errorMessage] ?? const AuthErrorUnknown();
  }
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: "Authentication error",
          dialogText: "Unknown authentication error",
        );

  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///email-already-exists
@immutable
class AuthErrorEmailAlreadyExists extends AuthError {
  const AuthErrorEmailAlreadyExists()
      : super(
          dialogTitle: "Email already in use",
          dialogText: "Please choose another email to register with!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///id-token-expired
@immutable
class AuthErrorTokenExpired extends AuthError {
  const AuthErrorTokenExpired()
      : super(
          dialogTitle: "Session Expired",
          dialogText: "Your session has expired. Please sign in again!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///id-token-revoked
@immutable
class AuthErrorTokenRevoked extends AuthError {
  const AuthErrorTokenRevoked()
      : super(
          dialogTitle: "Invalid Email",
          dialogText: "Please enter a valid email address!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: "Operation not allowed",
          dialogText: "You cannot register using this method at this moment!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///operation-not-allowed

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: "Operation not allowed",
          dialogText: "You cannot register using this method at this moment!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: "User not found!",
          dialogText: "No current user with this information was found!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: "Requires recent login",
          dialogText:
              "You need to log out and log back in again in order to perform this operation",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: "Weak password",
          dialogText:
              "Please choose a stronger password consisting of more characters!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

/// user-mismatch
@immutable
class AuthErrorUserMismatch extends AuthError {
  const AuthErrorUserMismatch()
      : super(
          dialogTitle: "Wrong email or password",
          dialogText: "Please verify your email and password and try again.",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///wrong-password
@immutable
class AuthErrorWrongPassword extends AuthError {
  const AuthErrorWrongPassword()
      : super(
          dialogTitle: "User Mismatch",
          dialogText:
              "The provided credential does not correspond to the user!",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

///too-many-requests
@immutable
class AuthErrorTooManyRequests extends AuthError {
  const AuthErrorTooManyRequests()
      : super(
          dialogTitle: "To many failed login attempts",
          dialogText:
              "Access to this account has been temporarily disabled due to many failed login attempts.",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}

//network_error
@immutable
class AuthErrorNetworkError extends AuthError {
  const AuthErrorNetworkError()
      : super(
          dialogTitle: "Connection Error!",
          dialogText: "Please check your internet connection and try again.",
        );
  @override
  List<Object?> get props => [super.dialogText, super.dialogTitle];
}
