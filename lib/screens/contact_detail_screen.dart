import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konnections/app/model/my_contact.dart';
import 'package:konnections/app/service/firestore_service/database.dart';
import 'package:konnections/app/widgets/my_container.dart';
import 'package:konnections/app/widgets/action_button.dart';
import 'package:konnections/app/widgets/platform_exception_alert_dialog.dart';
import 'package:konnections/app/utils/extension_firstCaps.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({
    @required this.database,
    this.myContact,
  });

  final Database database;
  final MyContact myContact;

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Database get database => widget.database;
  MyContact get myContact => widget.myContact;

  final _formKey = GlobalKey<FormState>();
  String givenName, familyName, phoneNumber, email;

  final FocusScopeNode _node = FocusScopeNode();

  @override
  void initState() {
    if (myContact != null) {
      givenName = myContact.givenName;
      familyName = myContact.familyName;
      phoneNumber = myContact.phoneNumber;
      email = myContact.email;
    }
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  String getInitials() {
    return ((this.givenName?.isNotEmpty == true ? this.givenName[0] : "") +
            (this.familyName?.isNotEmpty == true ? this.familyName[0] : ""))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(context),
      body: _mainContent(database, myContact),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: 0.0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: flatButtonTextStyle(context))),
      actions: [
        FlatButton(
            onPressed: _save,
            child: Text('Save', style: flatButtonTextStyle(context)))
      ],
    );
  }

  TextStyle flatButtonTextStyle(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).buttonColor,
      );

  Widget _mainContent(Database database, MyContact myContact) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CircleAvatar(
                child: myContact != null
                    ? Text(getInitials())
                    : Icon(EvaIcons.personOutline,
                        size: 30, color: Colors.white70),
                backgroundColor: Theme.of(context).accentColor,
                radius: 30,
              ),
              SizedBox(height: 30),
              myContact != null ? buttonRow(myContact) : Container(),
              myContact != null ? SizedBox(height: 30) : Container(),
              _contactForm()
            ],
          ),
        ),
      ),
    );
  }

  Row buttonRow(MyContact myContact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyContainerWithDarkMode(
            padding: 0.0,
            child: PhoneButton(phoneNumber: myContact.phoneNumber)),
        MyContainerWithDarkMode(
            padding: 0.0, child: SmsButton(phoneNumber: myContact.phoneNumber)),
        MyContainerWithDarkMode(
            padding: 0.0, child: EmailButton(email: myContact.email)),
      ],
    );
  }

  MyContainerWithDarkMode _contactForm() {
    return MyContainerWithDarkMode(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _givenNameTextFormField(),
                _familyNameTextFormField(),
                _phoneNumberTextFormField(),
                _emailTextFormField(),
                // MyFlatButton(onPressed: _save, text: 'SAVE'),
                // SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _givenNameTextFormField() {
    return TextFormField(
      initialValue: givenName,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) =>
          value.isNotEmpty ? null : 'Given/First name can\'t be empty',
      onSaved: (value) => givenName = value.firstCaps, //for save button
      onFieldSubmitted: (value) {
        givenName = value.firstCaps;
        _save();
      },
      onEditingComplete: () => _node.nextFocus(),
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.bodyText1,
      autofocus: myContact == null ? true : false,
      cursorColor: Theme.of(context).cursorColor,
      decoration: inputDecoration('Given/First Name'),
    );
  }

  TextFormField _familyNameTextFormField() {
    return TextFormField(
      initialValue: familyName,
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => (value != null || value.isNotEmpty)
          ? familyName = value
          : null, //for save button
      onFieldSubmitted: (value) {
        if (value != null || value.isNotEmpty) familyName = value.firstCaps;
        _save();
      },
      onEditingComplete: () => _node.nextFocus(),
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.bodyText1,
      cursorColor: Theme.of(context).cursorColor,
      decoration: inputDecoration('Family Name'),
    );
  }

  TextFormField _phoneNumberTextFormField() {
    return TextFormField(
      initialValue: phoneNumber,
      validator: (value) =>
          value.isNotEmpty ? null : 'Phone number can\'t be empty',
      onSaved: (value) => phoneNumber = value, //for save button
      onFieldSubmitted: (value) {
        phoneNumber = value;
        _save();
      },
      onEditingComplete: () => _node.nextFocus(),
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.bodyText1,
      cursorColor: Theme.of(context).cursorColor,
      decoration: inputDecoration('Phone number'),
    );
  }

  TextFormField _emailTextFormField() {
    return TextFormField(
      initialValue: email,
      onSaved: (value) => email = value, //for save button
      onFieldSubmitted: (value) {
        email = value;
        _save();
      },
      keyboardType: TextInputType.emailAddress,
      style: Theme.of(context).textTheme.bodyText1,
      cursorColor: Theme.of(context).cursorColor,
      decoration: inputDecoration('Email Address'),
    );
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyText2,
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).dividerColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).dividerColor)),
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    //validate
    if (form.validate()) {
      //save
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _save() async {
    if (_validateAndSaveForm()) {
      try {
        final id = myContact?.id ?? documentIdFromCurrentDate();

        final newContact = MyContact(
          id: id,
          displayName: '${givenName ?? ""} ${familyName ?? ""}',
          givenName: givenName ?? '',
          familyName: familyName ?? '',
          phoneNumber: phoneNumber ?? '',
          email: email ?? '',
        );
        //add newTodo to database
        await database.setContact(newContact);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
      Navigator.of(context).pop();
    }
  }
}
