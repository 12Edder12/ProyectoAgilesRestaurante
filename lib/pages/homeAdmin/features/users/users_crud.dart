import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    return _usersCollection.doc(id).update(data);
  }

  Future<void> deleteUser(String id) async {
    return _usersCollection.doc(id).delete();
  }
}

