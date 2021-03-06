import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/firestore_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final firestoreService = FirestoreService();

class TextControllerWithId extends TextEditingController {
  String id;
  TextControllerWithId({@required this.id});
}

class UserEntryScreen extends HookWidget {
  final User user;
  final roleController = TextControllerWithId(id: "role");
  final descController = TextControllerWithId(id: "desc");
  final nameController = TextControllerWithId(id: 'name');
  final List<TextControllerWithId> fields = [];

// Param wrapped in [] is an optional param
  UserEntryScreen([this.user]);

  @override
  Widget build(BuildContext context) {
    final fields = [nameController, roleController, descController];
    if (user != null) {
      nameController.text = user.name;
      roleController.text = user.role;
      descController.text = user.desc;
    }
    return Scaffold(
      appBar: AppBar(title: Text(user != null ? 'Update ${user.name}' : 'Add a User')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'User Name',
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: 'Role',
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: InputBorder.none,
              ),
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                user != null ? 'Update' : 'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                String userId;
                if (user != null) {
                  userId = user.id;
                }
                _validate(fields, userId);
              },
            ),
            (user != null)
                ? RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => firestoreService.deleteUser(user.id)
                    // Does not clear fields.
                    //.then((value) => clearFields(fields))
                    // If user is null, show empty container.
                    )
                : Container(),
          ],
        ),
      ),
    );
  }

  _validate(List<TextControllerWithId> fields, [String userId]) {
    var _user = new User();

    if (userId != null) {
      _user.id = userId;
    }
    // Desired: Get the name key from an interation of field.id, where id = name, role, or desc
    // _user[field.id] = field.text;

    fields.forEach((field) {
      if (field.text.isNotEmpty) {
        if (field.id == 'name') {
          _user.name = field.text;
        }
        if (field.id == 'role') {
          _user.role = field.text;
        }
        if (field.id == 'desc') {
          _user.desc = field.text;
        }
      } else {
        print('${field.id} required.');
      }
    });

    if (_user.name != null && _user.role != null && _user.desc != null) {
      firestoreService.upsertUser(_user).then((_) {
        print(_user.name);
        // nameController.text = 'foo'; // will change text field to display foo
        nameController.value = _user.name as TextEditingValue; // won't change text field to display user input - field snaps back to init value
        // if user is not null we are editing a user, so upon save, retain the values in the texfields.
        // else we are creating a new user so clear fields.
        // clearFields(fields);
      });
    } else {
      print('Please fill out all fields');
    }
  }

  void clearFields(fields) {
    fields.forEach((field) {
      field.clear();
    });
  }

  void dispose() {
    fields.forEach((field) {
      // print(field);
      field.dispose();
    });
    // Clean up the controller when the widget is removed from the widget tree.
  }
}
