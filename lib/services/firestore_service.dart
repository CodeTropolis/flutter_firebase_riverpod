import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final firebaseUserProvider = StreamProvider<List<User>>((ref) {
    final stream = FirebaseFirestore.instance.collection('users').snapshots();
    return stream.map((snapshot) => snapshot.docs.map((doc) {
          print('doc data: ${doc.data()}');
          return User.fromJson(doc.data());
        }).toList());
  });

  Future<void> setUser(User user) {
    // print('setUser: $user');
    var uuid = new Uuid();
    var _id = uuid.v4();
    var _user = new User(id: _id, name: user.name, role: user.role, desc: user.desc);
    return FirebaseFirestore.instance.collection('users').doc(_id).set(_user.toMap());
  }

  Future<void> deleteUser(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}
