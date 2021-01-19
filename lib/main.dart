import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

final firebaseUserProvider = StreamProvider<List<User>>((ref) {
  final stream = FirebaseFirestore.instance.collection('users').snapshots();
  return stream.map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Uber Angels')),
            body: useProvider(firebaseUserProvider).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text(err.toString())),
                data: (users) {
                  return ListView.separated(
                      separatorBuilder: (c, i) => Divider(color: Colors.black54),
                      itemCount: users.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: Icon(Icons.arrow_forward_ios),
                          title: Text(users[i].name),
                          subtitle: Text(users[i].role),
                        );
                      });
                })));
  }
}
