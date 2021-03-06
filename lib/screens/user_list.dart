import 'package:flutter_application_1/services/firestore_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:flutter_application_1/screens/user_entry.dart';
import 'package:location/location.dart';

final firestoreService = FirestoreService();

class UserList extends HookWidget {
  final Location location = Location();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location:'),
      ),
      body: useProvider(firestoreService.firebaseUserProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(err.toString())),
          data: (users) {
            // print('$location');
            return ListView.separated(
                separatorBuilder: (c, i) => Divider(color: Colors.black26),
                itemCount: users.length,
                itemBuilder: (c, i) {
                  return ListTile(
                      leading: Icon(Icons.arrow_forward_ios),
                      title: Text(users[i].name),
                      subtitle: Text(users[i].role),
                      trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => firestoreService.deleteUser(users[i].id)),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserEntryScreen(users[i]))));
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserEntryScreen()));
        },
      ),
    );
  }
}
