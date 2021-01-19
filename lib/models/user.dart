class User {
  final String name;
  final String role;

  User({this.name, this.role});

  // Data from Firebase is in JSON.
  // Convert from JSON to a Dart object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], role: json['role']);
  }

  // Convert data to JSON - required for sending data to Firebase.
  Map<String, dynamic> toMap() {
    return {'name': name, 'role': role};
  }
}
