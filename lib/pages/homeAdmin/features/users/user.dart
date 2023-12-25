import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  User({
    required this.userId,
    required this.idFirebase,
    required this.name,
    required this.apeUser,
    required this.celUser,
    required this.role,
    required this.dirUser,
    required this.email,
    required this.fecNacUser,
  });
  final String userId;
  final String idFirebase;
  final String name;
  final String role;
  final String apeUser;
  final String celUser;
  final String dirUser;
  final String email;
  final Timestamp fecNacUser;
}
