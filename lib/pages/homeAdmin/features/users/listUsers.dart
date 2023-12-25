

import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<List<User>> getUsers() {
  return firestore.collection('users').snapshots().map((snapshot) {
    final users = snapshot.docs.map((doc) {
      return User(
        idFirebase: doc.id,
        userId: doc['ced_user'],
        name: doc['nom_user'],
        apeUser: doc['ape_user'],
        celUser: doc['cel_user'],
        role: doc['cargo'],
        dirUser: doc['dir_user'],
        email: doc['email'],
        fecNacUser: doc['fec_nac_user'],
      );
    }).toList();

    users.sort((a, b) => _compareRoles(a.role, b.role));

    return users;
  });
}

int _compareRoles(String role1, String role2) {
  final roleOrder = {'admin': 1, 'Cocinero': 2, 'Mesero': 3};

  final role1Order = roleOrder[role1] ?? 4;
  final role2Order = roleOrder[role2] ?? 4;

  return role1Order.compareTo(role2Order);
}