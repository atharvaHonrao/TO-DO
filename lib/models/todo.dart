import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String name;
  String email;
  Map listitems;

  Todo({
    required this.name,
    required this.email,
    required this.listitems
  });

  Todo.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          listitems: json['listitems'] as Map
        );

  Todo copyWith({
    String? email,
    String? name,
    Map? listitems

  }) {
    return Todo(
      email: email ?? this.email,
      name: name ?? this.name,
      listitems: listitems ?? this.listitems
    );
  }

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'name':name,
      'listitems':listitems
    };
  }

  // factory Todo.fromMap(Map<String, dynamic> map) {
  //   return Todo(
  //     name: map['name'],
  //     email: map['email'],
  //     listitems: map['listitems'] ?? {},
  //   );
  // }
}
