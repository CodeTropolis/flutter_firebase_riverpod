import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:flutter_application_1/screens/entry.dart';

final firebaseUserProvider = StreamProvider<List<User>>((ref) {
  final stream = FirebaseFirestore.instance.collection('users').snapshots();
  return stream.map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
});

class UserList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: useProvider(firebaseUserProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(err.toString())),
          data: (users) {
            return ListView.separated(
                separatorBuilder: (c, i) => Divider(color: Colors.black54),
                itemCount: users.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    leading: Icon(Icons.arrow_forward_ios),
                    title: Text(users[i].name),
                    subtitle: Text(users[i].role),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EntryScreen()));
        },
      ),
    );
  }
}