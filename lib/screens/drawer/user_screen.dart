import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:konnections/app/constants/style.dart';
import 'package:konnections/app/constants/theme.dart';
import 'package:konnections/app/service/sign_in/firebase_auth_service.dart';
import 'package:konnections/app/widgets/avatar.dart';
import 'package:konnections/app/widgets/my_container.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';
import 'package:konnections/app/widgets/platform_exception_alert_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Spacer(),
          _mainContent(user),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  MyContainerWithDarkMode _mainContent(User user) {
    return MyContainerWithDarkMode(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Avatar(
              photoUrl: user.photoURL,
              radius: 40,
            ),
            SizedBox(height: 30),
            _buildNameRow(user),
            SizedBox(height: 20.0),
            _buildEmailRow(user),
            SizedBox(height: 20.0),
            _buildEmailVerifyRow(user),
            confirmVerifiedFlatButton(),
          ],
        ),
      ),
    );
  }

  Visibility confirmVerifiedFlatButton() {
    return Visibility(
      visible: _confirmVerifiedVisible,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _confirmVerified,
                  child: Text('I have verified my email address.',
                      style: KTextButton),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios,
            size: 30, color: Theme.of(context).buttonColor),
      ),
      actions: [
        _popup(),
      ],
    );
  }

  Row _buildNameRow(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: [
              Text('Name:', style: Theme.of(context).textTheme.bodyText1),
              SizedBox(width: 20),
              Expanded(
                child: Visibility(
                  visible: _nameVisible,
                  child: Text(
                      user.displayName == null || user.displayName.isEmpty
                          ? 'No added name yet.'
                          : user.displayName,
                      style: Theme.of(context).textTheme.subtitle1),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: !_nameVisible,
                  child: SizedBox(
                    width: 150,
                    child: textFormField(),
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(_nameVisible ? EvaIcons.edit2Outline : Icons.clear,
              size: 26, color: Theme.of(context).buttonColor),
          onPressed: _toggleVisibility,
        )
      ],
    );
  }

  TextFormField textFormField() {
    return TextFormField(
      autofocus: true,
      validator: (value) => value.isNotEmpty ? null : 'Content can\'t be empty',
      onFieldSubmitted: _onSubmittedName,
      cursorColor: Theme.of(context).cursorColor,
      maxLength: 15,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Row _buildEmailRow(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Email:', style: Theme.of(context).textTheme.bodyText1),
        SizedBox(width: 20.0),
        Text(
            user.email == null || user.email.isEmpty
                ? 'No registered email.'
                : user.email,
            style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }

  Widget _buildEmailVerifyRow(User user) {
    return user.isAnonymous
        ? Container()
        : user.emailVerified
            ? Row(
                children: [
                  Text('✔︎  Email verified',
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Text('Email not verified', style: KTextWarning),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: _verifyEmail,
                        child: Text('Verify email address', style: KTextButton),
                      )
                    ],
                  )
                ],
              );
  }

  ///notes for pop up to choose from gallery or camera
  PopupMenuButton<int> _popup() {
    return PopupMenuButton<int>(
        color: Theme.of(context).scaffoldBackgroundColor,
        icon: Icon(EvaIcons.moreHorizotnalOutline,
            color: Theme.of(context).buttonColor),
        offset: Offset(0, 50),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Logout"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete account"),
              ),
            ],
        onSelected: (int) {
          if (int == 1) {
            _confirmSignOut(context);
          }
          if (int == 2) {
            _confirmDelete(context);
          }
        });
  }

  bool _nameVisible = true;
  void _toggleVisibility() {
    setState(() {
      _nameVisible = !_nameVisible;
    });
  }

  void _onSubmittedName(String value) async {
    try {
      if (value.isNotEmpty) {
        /// from ProgressDialog plugin
        final ProgressDialog pr = ProgressDialog(
          context,
          type: ProgressDialogType.Normal,
          // textDirection: TextDirection.rtl,
          isDismissible: true,
        );
        prStyle(pr);

        await pr.show();

        final FirebaseAuthService auth =
            Provider.of<FirebaseAuthService>(context, listen: false);
        await auth.updateUserName(value);

        ///because it takes a while to update name
        await pr.hide();

        setState(() {
          _nameVisible = !_nameVisible;
        });
      }
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  void prStyle(ProgressDialog pr) {
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

  bool _confirmVerifiedVisible = false;
  Future<void> _verifyEmail() async {
    final User user = FirebaseAuth.instance.currentUser;

    try {
      await user.sendEmailVerification();
      await PlatformAlertDialog(
        title: 'Verification link sent',
        content: 'Please check your email to verify your account.',
        defaultActionText: 'OK',
      ).show(context);
      setState(() {
        _confirmVerifiedVisible = !_confirmVerifiedVisible;
      });
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  void _confirmVerified() {
    final User user = FirebaseAuth.instance.currentUser;
    user.reload();
    setState(() {
      _confirmVerifiedVisible = !_confirmVerifiedVisible;
    });
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.delete();
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Delete your account',
      content:
          'Warning: Your account and all of its data will be permanently deleted.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    ).show(context);
    if (didRequestSignOut == true) {
      _deleteAccount(context);
    }
  }

  Future<void> _showSignInError(BuildContext context, dynamic exception) async {
    PlatformExceptionAlertDialog(
      title: 'Operation failed',
      exception: exception,
    ).show(context);
  }
}
