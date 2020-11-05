import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konnections/app/model/my_contact.dart';
import 'package:konnections/app/service/firestore_service/database.dart';
import 'package:konnections/app/widgets/my_container.dart';

import 'build_sliver_list.dart';

class SearchResult extends StatefulWidget {
  final Database database;
  final String query;
  const SearchResult({Key key, this.database, this.query}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {
  Database get database => widget.database;
  String get query => widget.query;

  List<MyContact> filteredContacts = [];

  List<MyContact> _getFilteredContacts(List<MyContact> myContacts) {
    List<MyContact> filteredContacts = [];
    myContacts.forEach((myContact) {
      if (myContact.givenName.toLowerCase().contains(query.toLowerCase()) ||
          myContact.familyName.toLowerCase().contains(query.toLowerCase()))
        filteredContacts.add(myContact);
    });
    return filteredContacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: myContactsStreamBuilder(database),
    );
  }

  StreamBuilder myContactsStreamBuilder(Database database) {
    return StreamBuilder<List<MyContact>>(
        stream: database
            .contactsStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<MyContact> myContacts = snapshot.data;
            filteredContacts = _getFilteredContacts(myContacts);

            if (filteredContacts.isNotEmpty) {
              return CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  BuildSliverList(
                      database: database, myContacts: filteredContacts)
                ],
              );
            } else {
              return Center(
                  child: MyContainerWithDarkMode(
                      child: Text(
                'No contacts available, please add new contact.',
                style: Theme.of(context).textTheme.bodyText1,
              )));
            }
          } else if (snapshot.hasError) {
            return Center(
                child: MyContainerWithDarkMode(
                    child: Text(
              'Operation failed, please try again later.',
              style: Theme.of(context).textTheme.bodyText1,
            )));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
