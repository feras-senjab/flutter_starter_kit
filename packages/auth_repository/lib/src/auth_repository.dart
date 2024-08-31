import 'package:auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

/// Custom exception class for authentication errors.
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({
    this.message = "An unknown error occurred.",
    this.code,
  });

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}

/// Specific exception class for network-related errors.
class NetworkException extends AuthException {
  NetworkException(String message) : super(message: message);
}

/// Specific exception class for user-related errors (e.g., wrong password).
class UserErrorException extends AuthException {
  UserErrorException(String message) : super(message: message);
}

/// Repository for managing authentication with Firebase and Google Sign-In.
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn.standard(scopes: ['profile', 'email']);

  /// Checks if a user is currently signed in.
  bool isUserSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// Returns the current AuthUser if signed in, or an empty AuthUser otherwise.
  AuthUser getAuthUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return AuthUser(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        emailVerified: firebaseUser.emailVerified,
      );
    }
    return AuthUser.empty;
  }

  /// Registers a new user with email and password.
  Future<void> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, 'SignUp Error');
    }
  }

  /// Signs in a user with email and password.
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, 'SignIn Error');
    }
  }

  /// Sends a password reset email to the user.
  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, 'ForgotPassword Error');
    }
  }

  /// Signs in a user with Google account.
  ///
  /// Returns UserCredential object on success.
  ///
  /// Throws error on fail.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw UserErrorException("Google Sign-In was canceled.");
      }

      final googleSignInAuth = await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential;
    } catch (error) {
      developer.log(
        '$error',
        name: 'Google Sign In Error',
      );
      if (error is FirebaseAuthException) {
        _handleFirebaseAuthException(error, 'GoogleSignIn Error');
      } else {
        throw AuthException(
            message: "Google Sign-In failed. Please try again.");
      }
      // This return will never be hit because of the throw above, but satisfies the analyzer.
      return null;
    }
  }

  /// Signs out the current user from Firebase and Google.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (error) {
      developer.log(
        '$error',
        name: 'SignOut Error',
      );
      throw AuthException(message: "Failed to sign out. Please try again.");
    }
  }

  /// Deleting the current user.. be careful when and how to use this function..
  deleteCurrentUser() {
    _firebaseAuth.currentUser?.delete();
  }

  /// Handles FirebaseAuth exceptions and throws corresponding custom exceptions.
  void _handleFirebaseAuthException(FirebaseAuthException e, String context) {
    developer.log('$context: ${e.message}, Code: ${e.code}',
        name: 'AuthRepository');

    switch (e.code) {
      case "email-already-in-use":
      case "account-exists-with-different-credential":
        throw UserErrorException(
            "This email is already in use. Please log in instead.");

      case "wrong-password":
        throw UserErrorException("Incorrect password. Please try again.");

      case "user-not-found":
        throw UserErrorException(
            "No user found with this email. Please sign up.");

      case "user-disabled":
        throw UserErrorException("This user account has been disabled.");

      case "too-many-requests":
        throw UserErrorException("Too many attempts. Please try again later.");

      case "operation-not-allowed":
        throw AuthException(
            message: "Operation not allowed. Please contact support.",
            code: e.code);

      case "invalid-email":
        throw UserErrorException("The email address is invalid.");

      case "network-request-failed":
        throw NetworkException(
            "Network error. Please check your connection and try again.");

      default:
        throw AuthException(
            message: "An error occurred. Please try again.", code: e.code);
    }
  }
}
