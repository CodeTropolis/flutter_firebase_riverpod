import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore _db = FirebaseFirestore.instance;
CollectionReference _usersCollection = _db.collection('users');

class FirestoreService {
  final firebaseUserProvider = StreamProvider<List<User>>((ref) {
    final stream = _db.collection('users').snapshots();
    return stream.map((snapshot) => snapshot.docs.map((doc) {
          return User.fromJson(doc.data());
        }).toList());
  });

  // Future<void> getUser(String userId) {
  //   return _usersCollection.doc(userId).get();
  // }

  Future<void> upsertUser(User user) {
    // print(user.id);
    var uuid = new Uuid();
    var _id = uuid.v4();

    if (user.id != null) {
      return _usersCollection.doc(user.id).set(user.toMap());
    } else {
      var _user = new User(id: _id, name: user.name, role: user.role, desc: user.desc);
      return _usersCollection.doc(_id).set(_user.toMap());
    }
  }

  Future<void> deleteUser(String userId) {
    return _usersCollection.doc(userId).delete();
  }
}
