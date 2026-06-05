import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==========================
  // Google Sign In
  // ==========================
  Future<User?> signInWithGoogle() async {
    try {
      print("🚀 Starting Google Sign In...");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("❌ User cancelled Google Sign In");
        return null;
      }

      print("✅ Google account selected: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("✅ Access Token Received");
      print("✅ ID Token Received");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      print("✅ Firebase Login Success: ${userCredential.user?.email}");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("🔥 Firebase Auth Error");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      return null;
    } catch (e, stackTrace) {
      print("🔥 Google Sign In Error");
      print(e.toString());
      print(stackTrace);
      return null;
    }
  }

  // ==========================
  // Email Sign Up
  // ==========================
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print("✅ Account Created: ${credential.user?.email}");

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("🔥 Email Sign Up Error");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ==========================
  // Email Login
  // ==========================
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print("✅ Login Success: ${credential.user?.email}");

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("🔥 Email Login Error");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ==========================
  // Reset Password
  // ==========================
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

      print("✅ Password reset email sent");
    } catch (e) {
      print(e);
    }
  }

  // ==========================
  // Current User
  // ==========================
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ==========================
  // Logout
  // ==========================
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    await _auth.signOut();

    print("✅ User signed out");
  }
}
