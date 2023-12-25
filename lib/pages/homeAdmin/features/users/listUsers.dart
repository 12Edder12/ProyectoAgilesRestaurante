

import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List<User>> getUsers() async {
  final QuerySnapshot querySnapshot = await firestore.collection('users').get();
  return querySnapshot.docs.map((doc) {
    return User(
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
}