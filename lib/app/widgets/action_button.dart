import 'package:flutter/material.dart';
import 'package:konnections/app/utils/helperFunctions.dart';

class PhoneButton extends StatelessWidget {
  const PhoneButton({Key key, @required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.phone, color: Theme.of(context).buttonColor),
      onPressed: onPhoneButtonPressed(context),
    );
  }

  Function onPhoneButtonPressed(BuildContext context) {
    if (phoneNumber != null) {
      return () {
        HelperFunctions.callNumber(context, phoneNumber);
      };
    } else {
      return null;
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
      onPressed: onSmsButtonPressed(context),
    );
  }

  Function onSmsButtonPressed(BuildContext context) {
    if (phoneNumber != null) {
      return () {
        HelperFunctions.messagingDialog(context, phoneNumber);
      };
    } else {
      return null;
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
      onPressed: onSmsButtonPressed(context),
    );
  }

  Function onSmsButtonPressed(BuildContext context) {
    if (email != null) {
      return () {
        HelperFunctions.messagingDialog(context, email);
      };
    } else {
      return null;
    }
  }
}
