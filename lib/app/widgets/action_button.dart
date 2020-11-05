import 'package:flutter/material.dart';
import 'package:konnections/app/utils/helperFunctions.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';

class PhoneButton extends StatelessWidget {
  const PhoneButton({Key key, @required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.phone, color: Theme.of(context).buttonColor),
      onPressed: () => onPhoneButtonPressed(context),
    );
  }

  void onPhoneButtonPressed(BuildContext context) {
    if (phoneNumber != null) {
      HelperFunctions.callNumber(context, phoneNumber);
    } else {
      PlatformAlertDialog(
        title: "Error",
        content: 'Phone number is empty',
        defaultActionText: 'OK',
      ).show(context);
    }
  }
}

class SmsButton extends StatelessWidget {
  const SmsButton({Key key, @required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.message, color: Theme.of(context).buttonColor),
      onPressed: () => onSmsButtonPressed(context),
    );
  }

  void onSmsButtonPressed(BuildContext context) {
    if (phoneNumber != null) {
      HelperFunctions.messagingDialog(context, phoneNumber);
    } else {
      PlatformAlertDialog(
        title: "Error",
        content: 'Phone number is empty',
        defaultActionText: 'OK',
      ).show(context);
    }
  }
}

class EmailButton extends StatelessWidget {
  const EmailButton({Key key, @required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.email_outlined, color: Theme.of(context).buttonColor),
      onPressed: () => onEmailButtonPressed(context, email),
    );
  }

  void onEmailButtonPressed(BuildContext context, String email) {
    if (email != null) {
      HelperFunctions.launchEmail(context, email);
    } else {
      PlatformAlertDialog(
        title: "Error",
        content: 'Email address is empty',
        defaultActionText: 'OK',
      ).show(context);
    }
  }
}
