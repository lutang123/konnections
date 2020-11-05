import 'dart:async';
import 'package:meta/meta.dart';
import 'firestore_path.dart';
import '../../model/my_contact.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> setContact(MyContact contact); //create/update a data
  Future<void> deleteContact(MyContact contact); //delete a data
  Stream<MyContact> contactStream({@required String contactId}); //read one data
  Stream<List<MyContact>> contactsStream(); //read all data
}

//we use time as Id
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  //ensure only one object of FirestoreService is create
  final _service = FirestoreService.instance;

  /// contact
  @override //create or update job
  Future<void> setContact(MyContact contact) async => await _service.setData(
        path: FireStorePath.contact(uid, contact.id),
        data: contact.toMap(),
      );

  @override // delete job
  Future<void> deleteContact(MyContact contact) async {
    await _service.deleteData(path: FireStorePath.contact(uid, contact.id));
  }

  @override //read a job
  Stream<MyContact> contactStream({@required String contactId}) =>
      _service.documentStream(
        path: FireStorePath.contact(uid, contactId),
        builder: (data, documentId) => MyContact.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<MyContact>> contactsStream() => _service.collectionStream(
        path: FireStorePath.contacts(uid),
        builder: (data, documentId) => MyContact.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.displayName.compareTo(rhs.displayName),
      );
}
