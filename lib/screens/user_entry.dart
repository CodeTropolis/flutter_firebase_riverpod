import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/firestore_service.dart';

final firestoreService = FirestoreService();

class TextControllerWithId extends TextEditingController {
  String id;
  TextControllerWithId({@required this.id});
}

class UserEntryScreen extends StatelessWidget {
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
      appBar: AppBar(title: Text('Add a User')),
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
                'Save',
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
                    onPressed: () {},
                    // If user is null, show empty container.
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _validate(List controllers, [String userId]) {
    var _user = new User();

    if (userId != null) {
      _user.id = userId;
    }

    controllers.forEach((controller) {
      if (controller.text.isNotEmpty) {
        if (controller.id == 'name') {
          _user.name = controller.text;
        }
        if (controller.id == 'role') {
          _user.role = controller.text;
        }
        if (controller.id == 'desc') {
          _user.desc = controller.text;
        }
      } else {
        print('${controller.id} required.');
      }
    });

    if (_user.name != null && _user.role != null && _user.desc != null) {
      firestoreService.upsertUser(_user).then((_) {
        controllers.forEach((controller) {
          controller.text = ''; // clear fields
        });
      });
    } else {
      print('Please fill out all fields');
    }
  }

  void dispose() {
    fields.forEach((field) {
      print(field);
      field.dispose();
    });
    // Clean up the controller when the widget is removed from the widget tree.
  }
}
