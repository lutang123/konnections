import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konnections/app/constants/image_path.dart';
import 'package:konnections/app/constants/strings_sign_in.dart';
import 'package:konnections/app/constants/style.dart';
import 'package:konnections/app/constants/theme.dart';
import 'package:konnections/app/service/sign_in/firebase_auth_service.dart';
import 'package:konnections/app/widgets/my_container.dart';
import 'package:konnections/app/widgets/platform_exception_alert_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.signInImage),
                fit: BoxFit.cover,
              ),
            ),
            constraints: BoxConstraints.expand()),
        Scaffold(backgroundColor: Colors.transparent, body: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('KONNECTIONS', style: KSignInTitle),
              SizedBox(height: 30),
              mySignInContainerSocial('Sign In with Google', _signInWithGoogle)
            ],
          ),
        ),
      ),
    );
  }

  MyContainer mySignInContainerSocial(text, onTap) {
    return MyContainer(
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 30.0),
            ),
            Expanded(
              child:
                  Text(text, style: KSignInButton, textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    final FirebaseAuthService firebaseAuthService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    try {
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
      );
      progressDialogStyle(pr);
      await pr.show();
      await firebaseAuthService.signInWithGoogle();
      await pr.hide();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(e);
      }
      _showSignInError(e); // added
    }
  }

  void progressDialogStyle(ProgressDialog pr) {
    return pr.style(
      message: 'Please wait',
      borderRadius: 20.0,
      backgroundColor: darkThemeBkgdColor,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

  Future<void> _showSignInError(dynamic exception) async {
    PlatformExceptionAlertDialog(
      title: StringsSignIn.signInFailed,
      exception: exception,
    ).show(context);
  }
}
