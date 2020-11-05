import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:konnections/app/constants/theme.dart';
import 'package:konnections/app/model/my_contact.dart';
import 'package:konnections/app/service/firestore_service/database.dart';
import 'package:konnections/app/utils/helperFunctions.dart';
import 'package:konnections/app/widgets/my_container.dart';
import 'package:konnections/app/widgets/platform_exception_alert_dialog.dart';
import 'package:konnections/screens/search_contact_delegate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'build_sliver_list.dart';
import 'contact_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING =
      "HOME_IS_FIRST_LAUNCH_STRING";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences
            .getBool(HomeScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING) ??
        true;
    if (isFirstLaunch)
      sharedPreferences.setBool(
          HomeScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);
    return isFirstLaunch;
  }

  Future<void> _getContacts() async {
    final database = Provider.of<Database>(context, listen: false);
    final ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    // only get contact from phone once
    _isFirstLaunch().then((result) async {
      if (result) {
        //show a progress dialog since the uploading can take long time
        progressDialogStyle(pr);
        await pr.show();
        // step 1: get all contact from phone. We already have permissions for contact when we get to this page, so we are now just retrieving it
        final Iterable<Contact> contacts = await ContactsService.getContacts();
        // step 2: loop through each element
        contacts.forEach((element) async {
          //1: convert Contact to MyContact, to simplify the process, I only take some properties and only take the first value
          final MyContact myContact = MyContact(
            id: documentIdFromCurrentDate(), //unique id
            displayName: element.displayName,
            givenName: element.givenName,
            familyName: element.familyName,
            phoneNumber: HelperFunctions.getValidPhoneNumber(element.phones),
            email: HelperFunctions.getValidEmail(element.emails),
          );
          //2: save all the contact into Firebase CloudStore
          _addToCloudStore(database, myContact);
          await pr.hide();
        });
      }
    });
  }

  Future<void> _addToCloudStore(Database database, MyContact myContact) async {
    try {
      await database.setContact(myContact);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
        appBar: buildAppBar(context, database),
        body: myContactsStreamBuilder(database));
  }

  AppBar buildAppBar(BuildContext context, Database database) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Contacts', style: Theme.of(context).textTheme.headline5),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.person_add_alt,
                color: Theme.of(context).buttonColor),
            onPressed: () => _add(database)),
      ],
    );
  }

  StreamBuilder myContactsStreamBuilder(Database database) {
    return StreamBuilder<List<MyContact>>(
        stream: database
            .contactsStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<MyContact> myContacts = snapshot.data;
            if (myContacts.isNotEmpty) {
              return CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  _buildBoxAdaptorForSearch(database, myContacts),
                  BuildSliverList(database: database, myContacts: myContacts),
                ],
              );
            } else {
              return Center(
                  child: Text(
                'No contacts available, please add new contact.',
                style: Theme.of(context).textTheme.bodyText1,
              ));
            }
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Operation failed, please try again later.',
              style: Theme.of(context).textTheme.bodyText1,
            ));
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildBoxAdaptorForSearch(
      Database database, List<MyContact> myContacts) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
        child: SearchBar(
          onTap: () => showSearch(
            context: context,
            delegate: SearchContact(database: database, myContacts: myContacts),
          ),
        ),
      ),
    );
  }

  Future<void> _add(Database database) async {
    await showCupertinoModalBottomSheet(
        useRootNavigator: true,
        expand: true,
        context: context,
        builder: (context, scrollController) =>
            ContactDetailScreen(database: database));
  }

  void progressDialogStyle(ProgressDialog pr) {
    return pr.style(
      message: 'Please wait, syncing contacts with cloud database.',
      borderRadius: 20.0,
      backgroundColor: darkThemeBkgdColor,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }
}
