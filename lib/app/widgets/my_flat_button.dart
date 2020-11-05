import 'package:flutter/material.dart';

class MyFlatButton extends StatelessWidget {
  const MyFlatButton({
    @required this.onPressed,
    @required this.text,
    this.bkgdColor = Colors.transparent,
  });

  final VoidCallback onPressed;
  final String text;
  final Color bkgdColor;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(68.0),
          side: BorderSide(color: Theme.of(context).buttonColor, width: 1.5)),
      color: bkgdColor,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
              fontFamily: "varelaRound"),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MyFlatIconButton extends StatelessWidget {
  const MyFlatIconButton({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onPressed,
    this.color = Colors.transparent,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton.icon(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side:
                BorderSide(color: Theme.of(context).dividerColor, width: 1.0)),
        icon: Icon(icon, color: Theme.of(context).buttonColor),
        onPressed: onPressed,
        label: Text(
          text,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
