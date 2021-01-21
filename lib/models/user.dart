class User {
  String id;
  String name;
  String role;
  String desc;

  User({this.id, this.name, this.role, this.desc});

  // Data from Firebase is in JSON.
  // Convert from JSON to a Dart object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], role: json['role'], desc: json['desc']);
  }

  // Convert data to JSON - required for sending data to Firebase.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'role': role, 'desc': desc};
  }
}
