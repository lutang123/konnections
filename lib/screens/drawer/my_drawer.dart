import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konnections/app/constants/image_path.dart';
import 'package:konnections/app/constants/strings.dart';
import 'package:konnections/app/constants/theme.dart';
import 'package:konnections/app/service/theme_notifier.dart';
import 'package:konnections/app/utils/shared_axis.dart';
import 'package:konnections/app/widgets/avatar.dart';
import 'package:konnections/app/widgets/my_tooltip.dart';
import 'package:konnections/app/widgets/setting_switch.dart';
import 'package:konnections/screens/drawer/user_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contact_us_screen.dart';
import 'package:konnections/app/utils/extension_firstCaps.dart';

class MyDrawer extends StatefulWidget {
  final Widget child;
  const MyDrawer({Key key, this.child}) : super(key: key);
  static MyDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<MyDrawerState>();
  @override
  MyDrawerState createState() => new MyDrawerState();
}

class MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void open() => animationController.forward();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      // onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                image: AssetImage(ImagePath.signInImage),
                fit: BoxFit.cover,
              ))),
              Material(
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    Transform.translate(
                      offset:
                          Offset(maxSlide * (animationController.value - 1), 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                              math.pi / 2 * (1 - animationController.value)),
                        alignment: Alignment.centerRight,
                        child: MyHomeDrawer(),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(maxSlide * animationController.value, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-math.pi * animationController.value / 2),
                        alignment: Alignment.centerLeft,
                        child: widget.child,
                      ),
                    ),
                    Positioned(
                      top: height > 700
                          ? MediaQuery.of(context).padding.top
                          : MediaQuery.of(context).padding.top + 10,
                      left: 5 + animationController.value * maxSlide,
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.bars),
                        onPressed: toggle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyHomeDrawer extends StatelessWidget {
  final SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;

    // /// do not set listen to false here
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                settingTitle(context, title: 'Settings'),
                MyToolTip(
                  message: Strings.themeSwitchTip,
                  child: SettingSwitch(
                    icon: FontAwesomeIcons.adjust,
                    title: 'Dark Theme',
                    value: _darkTheme,
                    onChanged: (val) {
                      _darkTheme = val;
                      _onThemeChanged(val, themeNotifier);
                    },
                  ),
                ),
                settingDivider(context),
                ListTile(
                  leading: Avatar(
                    photoUrl: user.photoURL,
                    radius: 13,
                  ),
                  title: user.displayName == null || user.displayName.isEmpty
                      ? Text('User Profile',
                          style: Theme.of(context).textTheme.bodyText1)
                      : Text(user.displayName.firstCaps,
                          style: Theme.of(context).textTheme.bodyText1),
                  trailing: Icon(Icons.chevron_right,
                      color: Theme.of(context).buttonColor),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: UserScreen(), transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                settingListTile(
                  context,
                  icon: FontAwesomeIcons.directions,
                  title: 'Contact Us',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: ContactUsScreen(),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// this is StatelessWidget, all the method outside of build do not have context, so we need to add BuildContext context
  /// and it will still show flush bar
  ListTile settingTitle(BuildContext context, {String title}) {
    return ListTile(
      leading: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  ListTile settingListTile(BuildContext context,
      {IconData icon, String title, Function onTap}) {
    return ListTile(
        leading: Icon(icon, color: Theme.of(context).buttonColor),
        title: Text(title, style: Theme.of(context).textTheme.bodyText1),
        trailing:
            Icon(Icons.chevron_right, color: Theme.of(context).buttonColor),
        onTap: onTap);
  }

  Widget settingDivider(BuildContext context) {
    return Divider(
        indent: 50,
        endIndent: 50,
        color: Theme.of(context).dividerColor,
        thickness: 1);
  }

  Future<void> _onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
