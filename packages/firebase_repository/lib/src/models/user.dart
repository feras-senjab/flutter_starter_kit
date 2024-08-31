import 'dart:convert';

import 'package:equatable/equatable.dart';

class FirebaseUserModel extends Equatable {
  final String id;
  final String name;
  final String email;

  const FirebaseUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [id, name, email];

  FirebaseUserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return FirebaseUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory FirebaseUserModel.fromMap(Map<String, dynamic> map) {
    return FirebaseUserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUserModel.fromJson(String source) =>
      FirebaseUserModel.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
