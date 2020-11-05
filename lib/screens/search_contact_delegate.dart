import 'package:flutter/material.dart';
import 'package:konnections/app/model/my_contact.dart';
import 'package:konnections/app/service/firestore_service/database.dart';
import 'package:konnections/screens/search_result.dart';

class SearchContact extends SearchDelegate<MyContact> {
  SearchContact({this.myContacts, this.database});
  final List<MyContact> myContacts;
  final Database database;

  List<MyContact> filteredContacts = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
      cursorColor: Theme.of(context).cursorColor,
      hintColor: Theme.of(context).hintColor,
      primaryColor: Theme.of(context).scaffoldBackgroundColor,
    );
    assert(theme != null);
    return theme;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).buttonColor,
          size: 30,
        ),
        onPressed: () => close(context, null));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query == '' || query == null
          ? Container()
          : IconButton(
              icon: Icon(Icons.clear, color: Theme.of(context).buttonColor),

              ///this query is pre-built, not need to create a query variable
              onPressed: () => query = '',
            )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '' || query == null) {
      return searchStartContent(context);
    } else {
      return SearchResult(
        database: database,
        query: query,
      );
    }
  }

  Widget searchStartContent(BuildContext context) {
    return Center(
        child: Text('Enter a keywords to search.',
            style: Theme.of(context).textTheme.bodyText1));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '' || query == null) {
      return searchStartContent(context);
    } else {
      return SearchResult(
        database: database,
        query: query,
      );
    }
  }
}
