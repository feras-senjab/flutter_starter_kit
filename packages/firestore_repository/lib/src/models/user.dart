import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../firestore_helpers/firestore_field_updater.dart';

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

  static const empty = FirestoreUserModel(
    id: '',
    name: '',
    email: '',
  );

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

  /// Creates a map of updates for Firestore fields based on the provided FirestoreFieldUpdater instances.
  ///
  /// The method allows selective updates while ensuring that only modified fields are included in the map.
  Map<String, dynamic> toUpdateMap({
    FirestoreFieldUpdater<String>? id,
    FirestoreFieldUpdater<String>? name,
    FirestoreFieldUpdater<String>? email,
    FirestoreFieldUpdater<String>? avatarUrl,
    FirestoreFieldUpdater<String>? about,
  }) {
    final Map<String, dynamic> updateMap = {};

    if (id != null && id.fieldValue != this.id) {
      updateMap['id'] = id.fieldValue;
    }
    if (name != null && name.fieldValue != this.name) {
      updateMap['name'] = name.fieldValue;
    }
    if (email != null && email.fieldValue != this.email) {
      updateMap['email'] = email.fieldValue;
    }
    if (avatarUrl != null && avatarUrl.fieldValue != this.avatarUrl) {
      updateMap['avatarUrl'] = avatarUrl.fieldValue;
    }
    if (about != null && about.fieldValue != this.about) {
      updateMap['about'] = about.fieldValue;
    }

    return updateMap;
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
