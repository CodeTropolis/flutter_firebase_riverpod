import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';

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
      appBar: AppBar(title: Text('Add a User'), actions: [
        IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _pickDate(context).then((value) {
                print(value);
              });
            }),
      ]),
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

  Future<DateTime> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2030));
    if (picked != null) return picked;
  }

  _validate(List controllers) {
    controllers.forEach((controller) {
      (controller.text.isNotEmpty)
          ? print(controller.text)
          : print('${controller.id} required.');
      controller.text = ''; // clear fields
    });
  }
}
