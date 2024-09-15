import 'dart:convert';

import 'package:equatable/equatable.dart';

class FirebaseUserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  //TODO: when implementing more fields.. test and confirm the case of adding field to doc that doesn't have this field in firestore.
  final String? avatarUrl;
  final String? about;

  const FirebaseUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.about,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      avatarUrl,
      about,
    ];
  }

  FirebaseUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? about,
  }) {
    return FirebaseUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      about: about ?? this.about,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'about': about,
    };
  }

  factory FirebaseUserModel.fromMap(Map<String, dynamic> map) {
    return FirebaseUserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      about: map['about'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUserModel.fromJson(String source) =>
      FirebaseUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FirebaseUserModel(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, about: $about)';
  }
}
