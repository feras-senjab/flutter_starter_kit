import 'dart:convert';

import 'package:equatable/equatable.dart';

class FirestoreUserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  //TODO: when implementing more fields.. test and confirm the case of adding field to doc that doesn't have this field in firestore.
  final String? avatarUrl;
  final String? about;

  const FirestoreUserModel({
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

  FirestoreUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? about,
  }) {
    return FirestoreUserModel(
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

  factory FirestoreUserModel.fromMap(Map<String, dynamic> map) {
    return FirestoreUserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      about: map['about'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FirestoreUserModel.fromJson(String source) =>
      FirestoreUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FirestoreUserModel(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, about: $about)';
  }
}
