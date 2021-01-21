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

  UserEntryScreen({this.user});

  @override
  Widget build(BuildContext context) {
    final fields = [nameController, roleController, descController];
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
                _validate(fields);
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
                : Container()
          ],
        ),
      ),
    );
  }

  _validate(List controllers) {
    controllers.forEach((controller) {
      if (controller.text.isNotEmpty) {
        print('${controller.id}:${controller.text}');
      } else {
        print('${controller.id} required.');
      }

      // final User _user = controller.id : controller.text; // i.e. name:"Frank", role:"Guardian", desc:"Foo ipsum..."

      controller.text = ''; // clear fields
    });
  }

  void dispose() {
    fields.forEach((field) {
      field.dispose();
    });
    // Clean up the controller when the widget is removed from the widget tree.
  }
}
