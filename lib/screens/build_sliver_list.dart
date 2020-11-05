import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:konnections/app/constants/style.dart';
import 'package:konnections/app/model/my_contact.dart';
import 'package:konnections/app/service/firestore_service/database.dart';
import 'package:konnections/app/widgets/my_container.dart';
import 'dart:math' as math;
import 'package:konnections/app/widgets/action_button.dart';
import 'package:konnections/app/widgets/platform_exception_alert_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'contact_detail_screen.dart';

class BuildSliverList extends StatefulWidget {
  final Database database;
  final List<MyContact> myContacts;

  const BuildSliverList({Key key, this.database, this.myContacts})
      : super(key: key);
  @override
  _BuildSliverListState createState() => _BuildSliverListState();
}

class _BuildSliverListState extends State<BuildSliverList> {
  Database get database => widget.database;
  List<MyContact> get myContacts => widget.myContacts;

  @override
  Widget build(BuildContext context) {
    return _buildSliverList(database, myContacts);
  }

  Widget _buildSliverList(Database database, List<MyContact> myContacts) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            return _buildSlidable(database, myContacts, itemIndex + 1);
          }
          return _myListDivider();
        },
        semanticIndexCallback: (Widget widget, int localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount: math.max(0, myContacts.length * 2 - 1),
      ),
    );
  }

  Slidable _buildSlidable(
      Database database, List<MyContact> myContacts, int index) {
    return Slidable(
      key: UniqueKey(),
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildListTile(database, myContacts[index - 1]),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          foregroundColor: Colors.blue,
          color: Theme.of(context).scaffoldBackgroundColor,
          iconWidget: Icon(
            EvaIcons.edit2Outline,
            color: Colors.blue,
          ),
          onTap: () => _update(database, myContacts[index - 1]),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          foregroundColor: Colors.red,
          color: Theme.of(context).scaffoldBackgroundColor,
          iconWidget: Icon(
            EvaIcons.trash2Outline,
            color: Colors.red,
          ),
          onTap: () => _delete(database, myContacts[index - 1]),
        ),
      ],
    );
  }

  ListTile _buildListTile(Database database, MyContact myContact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
      leading: CircleAvatar(
        child: Text(myContact.initials() ?? ''),
        backgroundColor: Theme.of(context).accentColor,
      ),
      title: Text(myContact.displayName ?? ''),
      onTap: () => _update(database, myContact),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PhoneButton(phoneNumber: myContact.phoneNumber),
          SmsButton(phoneNumber: myContact.phoneNumber)
        ],
      ),
    );
  }

  Divider _myListDivider() {
    return Divider(
      indent: 75,
      endIndent: 75,
      height: 0.5,
      color: Theme.of(context).dividerColor,
    );
  }

  Future<void> _update(Database database, MyContact myContact) async {
    await showCupertinoModalBottomSheet(
        useRootNavigator: true,
        expand: true,
        context: context,
        builder: (context, scrollController) =>
            ContactDetailScreen(database: database, myContact: myContact));
  }

  Future<void> _delete(
    Database database,
    MyContact myContact,
  ) async {
    try {
      await database.deleteContact(myContact);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
    // show a flush bar for undo action
    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
          onPressed: () => database.setContact(myContact),
          child: FlushBarButtonChild(
            title: 'UNDO',
          )),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 4),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          'Deleted: ',
          style: KFlushBarTitle,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(
          myContact.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage,
        ),
      ),
    )..show(context);
  }
}
