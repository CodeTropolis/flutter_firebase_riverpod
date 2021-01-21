import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:hooks_riverpod/all.dart';

class FirestoreService {
  final firebaseUserProvider = StreamProvider<List<User>>((ref) {
    final stream = FirebaseFirestore.instance.collection('users').snapshots();
    return stream.map((snapshot) => snapshot.docs.map((doc) => User.fromJson({'id': doc.id, ...doc.data()})).toList());
  });

  Future<void> setUser(User user) {
    return FirebaseFirestore.instance.collection('users').add(user.toMap());
  }

  Future<void> deleteUser(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}
