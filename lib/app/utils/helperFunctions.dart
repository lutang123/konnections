import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:konnections/app/widgets/messagingDialog.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

class HelperFunctions {
  static Future<void> initiateMessage(
      BuildContext context, String message, String recipient) async {
    await sendSMS(message: message, recipients: <String>[recipient])
        .catchError((dynamic onError) {
      platformAlertDialog(onError).show(context);
    });
  }

  static Future<void> callNumber(
      BuildContext context, String phoneNumber) async {
    phoneNumber = phoneNumber.replaceAll(RegExp(r"[^\w]"), "");
    bool _result =
        await launch('tel:' + phoneNumber).catchError((dynamic onError) {
      platformAlertDialog(onError).show(context);
    });
    if (_result == false) {
      platformAlertDialogFail().show(context);
    }
  }

  static Future<void> launchEmail(BuildContext context, String email) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: '$email',
        queryParameters: {
          'subject': 'Example Subject & Symbols are allowed!'
        }); //add subject and body here
    var url = _emailLaunchUri.toString();
    if (await canLaunch(url)) {
      bool _result = await launch(url).catchError((dynamic onError) {
        platformAlertDialog(onError).show(context);
      });
      if (_result == false) {
        platformAlertDialogFail().show(context);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  static PlatformAlertDialog platformAlertDialog(onError) {
    return PlatformAlertDialog(
      title: "Error",
      content: onError.toString(),
      defaultActionText: 'OK',
    );
  }

  static PlatformAlertDialog platformAlertDialogFail() {
    return PlatformAlertDialog(
      title: "Error",
      content: 'Operation failed',
      defaultActionText: 'OK',
    );
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
