import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:konnections/app/widgets/messagingDialog.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunctions {
  static Future<void> initiateMessage(
      BuildContext context, String message, String recipient) async {
    final String _result =
        await sendSMS(message: message, recipients: <String>[recipient])
            .catchError((dynamic onError) {
      PlatformAlertDialog(
        title: "Error",
        content: onError.toString(),
        defaultActionText: 'OK',
      );
    });
    print(_result);
  }

  static Future<void> callNumber(BuildContext context, String number) async {
    number = number.replaceAll(RegExp(r"[^\w]"), "");
    bool _result = await launch('tel:' + number).catchError((dynamic onError) {
      PlatformAlertDialog(
        title: "Error",
        content: onError.toString(),
        defaultActionText: 'OK',
      );
    });
    if (_result == false) {
      PlatformAlertDialog(
        title: "Error",
        content: 'Operation failed',
        defaultActionText: 'OK',
      );
    }
  }

  static String getValidPhoneNumber(Iterable phoneNumbers) {
    if (phoneNumbers != null && phoneNumbers.toList().isNotEmpty) {
      List phoneNumbersList = phoneNumbers.toList();
      // This takes first available number. Can change this to display all
      // numbers first and let the user choose which one use.
      return phoneNumbersList[0].value;
    }
    return null;
  }

  static String getValidEmail(Iterable emails) {
    if (emails != null && emails.toList().isNotEmpty) {
      List emailList = emails.toList();
      return emailList[0].value;
    }
    return null;
  }

  static void messagingDialog(BuildContext context, String recipient) {
    showDialog<Dialog>(
        context: context,
        builder: (BuildContext context) {
          return MessagingDialog(
              messageCallback: initiateMessage, recipient: recipient);
        });
  }
}
