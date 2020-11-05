import 'package:flutter/material.dart';
import 'package:konnections/app/constants/theme.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({Key key, this.child, this.height, this.padding = 15})
      : super(key: key);
  final Widget child;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: lightThemeBkgdColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      height: height,
      child: child,
    );
  }
}

// in home screen error, user screen, folder screen
class MyContainerWithDarkMode extends StatelessWidget {
  const MyContainerWithDarkMode({
    Key key,
    this.child,
    this.padding = 15.0,
  }) : super(key: key);
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 4.0,
            ),
          ],
          borderRadius: BorderRadius.circular(20.0)),
      child: Center(child: child),
    );
  }
}

class SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const SearchBar({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            border:
                Border.all(width: 0.5, color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                  onPressed: onTap,
                  icon:
                      Icon(Icons.search, color: Theme.of(context).buttonColor),
                  label: Text(
                    'Search your contacts',
                    style: TextStyle(
                        color: Theme.of(context).cursorColor.withOpacity(0.8)),
                  )),
            ],
          ),
        ));
  }
}

class FlushBarButtonChild extends StatelessWidget {
  final String title;
  const FlushBarButtonChild({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white54),
          borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
