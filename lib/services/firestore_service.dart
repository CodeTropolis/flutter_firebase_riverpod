import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:hooks_riverpod/all.dart';

class FirestoreService {
  final firebaseUserProvider = StreamProvider<List<User>>((ref) {
    final stream = FirebaseFirestore.instance.collection('users').snapshots();
    return stream.map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  });
}