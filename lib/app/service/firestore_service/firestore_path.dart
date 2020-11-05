class FireStorePath {
  //contact
  static String contact(String uid, String contactId) =>
      'users/$uid/contacts/$contactId';
  static String contacts(String uid) => 'users/$uid/contacts';
}
