import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

// FirebaseFirestore _db = FirebaseFirestore.instance;

final firebaseUserProvider = StreamProvider<List<User>>((ref) {
  final stream = FirebaseFirestore.instance.collection('users').snapshots();
  print(stream.map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()));
  return stream.map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
});

// Stream<List<User>> getUsers() {
//   return _db
//   .collection('users')
//   .snapshots()
//   .map((snapshot) => snapshot.docs
//   .map((doc) => User.fromJson(doc.data)))
//   .toList());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final value = useProvider(firebaseUserProvider);
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('Example')),
      // body: Center(child: List<User>(value)),
    ));
  }
}
