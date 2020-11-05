import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konnections/app/constants/image_path.dart';
import 'package:konnections/app/widgets/platform_alert_dialog.dart';
import 'package:konnections/screens/tab_page/tab_page.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    _getUserPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.signInImage),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Container(),
      ),

      // Center(
      //   child: RaisedButton(
      //     //verifies and retrieves contact-access permissions before attempting to display contacts.
      //     onPressed: _getUserPermission,
      //     child: Container(child: Text('See Contacts')),
      //   ),
      // ),
    );
  }

  Future<void> _getUserPermission() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TabPage()));
    } else {
      await PlatformAlertDialog(
        title: 'Permissions error',
        content: 'Please enable contacts access permission in system settings.',
        defaultActionText: 'Ok',
      ).show(context);
    }
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
