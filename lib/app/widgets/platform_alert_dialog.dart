import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:konnections/app/constants/style.dart';
import 'package:konnections/app/widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.headline6),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(content, style: Theme.of(context).textTheme.bodyText1),
      ),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(title, style: Theme.of(context).textTheme.headline6),
      content: Text(content, style: Theme.of(context).textTheme.bodyText1),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        FlatButton(
          child: Text(cancelActionText, style: KDialogButton),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      FlatButton(
        child: Text(defaultActionText, style: KDialogButton),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}
