import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final Function onChanged;
  final double size;

  const SettingSwitch({
    Key key,
    this.icon,
    this.title,
    this.value,
    this.onChanged,
    this.size = 23,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: size,
        color: Theme.of(context).buttonColor,
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyText1),
      trailing: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          activeColor: Theme.of(context).buttonColor,
          trackColor: Colors.grey,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
