import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required dynamic exception,
  }) : super(
            title: title,
            content: _message(exception),
            defaultActionText: 'OK');

  static String _message(dynamic exception) {
    if (exception is FirebaseException) {
      return exception.message;
    }
    if (exception is PlatformException) {
      return exception.message;
    }
    return exception.toString();
  }
}

//Future<void> showExceptionAlertDialog({
//     @required BuildContext context,
//     @required String title,
//     @required dynamic exception,
//   }) =>
//       PlatformAlertDialog(
//         title: title,
//         content: _message(exception),
//         defaultActionText: 'OK',
//       ).show(context);
//
//   String _message(dynamic exception) {
//     if (exception is FirebaseException) {
//       return exception.message;
//     }
//     if (exception is PlatformException) {
//       return exception.message;
//     }
//     return exception.toString();
//   }
