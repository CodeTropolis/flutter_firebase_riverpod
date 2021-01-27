import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user_entry.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_application_1/screens/user_list.dart';
import 'package:flutter_application_1/services/firestore_service.dart';
import 'package:hooks_riverpod/all.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

final firestoreService = FirestoreService();

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final users = useProvider(firestoreService.firebaseUserProvider);
    return users.when(
        data: (users) {
          if (users.length > 0) {
            return MaterialApp(home: UserList());
          } else {
            return MaterialApp(home: UserEntryScreen());
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())));
  }
}
