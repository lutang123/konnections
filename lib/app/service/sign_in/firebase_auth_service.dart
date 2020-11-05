import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:konnections/app/constants/strings_sign_in.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInAnonymously({String name}) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInAnonymously();
    final User user = userCredential.user; //this is current user
    await user.updateProfile(displayName: name);
    await user.reload();
    return userCredential;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user; //this is current user
      await user.updateProfile(displayName: name);
      await user.reload();
      // then we call currentUser again.
      final User currentUser = _firebaseAuth.currentUser; //this is current user
      //verify email
      if (!currentUser.emailVerified) {
        await currentUser.sendEmailVerification();
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        await PlatformAlertDialog(
          title: 'Registration failed',
          content: 'The password provided is too weak.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
      }
      if (e.code == 'email-already-in-use') {
        await PlatformAlertDialog(
          title: 'Registration failed',
          content: 'The account already exists for that email.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User firebaseUser = userCredential.user; //this is current user
      //we can not remove this if we want to update user name
      await firebaseUser.updateProfile(displayName: name);
      await firebaseUser.reload();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await PlatformAlertDialog(
          title: 'Sign in failed',
          content: 'No user found for that email.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
      }
      if (e.code == 'wrong-password') {
        await PlatformAlertDialog(
          title: 'Sign in failed',
          content: 'Wrong password provided for that user.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> updateUserName(String name) async {
    final User user = _firebaseAuth.currentUser;
    await user.updateProfile(displayName: name);
    await user.reload();
    return user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // Obtain the auth details from the request
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        // Once signed in, return the UserCredential
        return userCredential;
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  User get currentUser => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  Future<void> delete() async {
    await FirebaseAuth.instance.currentUser.delete();
  }
}
