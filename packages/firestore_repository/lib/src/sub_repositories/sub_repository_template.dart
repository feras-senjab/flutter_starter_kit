// ignore_for_file: unused_element, unused_import

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../config.dart';

import '../base_firestore_repository/base_firestore_repository.dart';

import '../firestore_helpers/firestore_field_updater.dart';
import '../models/models.dart';

//------------------------------------------------------------------------------//
//! This file not to be used anywhere.. don't export it or use it..
//! it's just to explain how to extend base_firestore_repository with sub_repository.
// We have base_firestore_repository that implements most common CRUD operations.
// And we can make sub_repositroy like the following to extend the base_firestore_repository
// and be able to use its functions..
// For our sub_repository we'll need to have sub_model to use its fromMap and toMap with the functions.
//------------------------------------------------------------------------------//
// First.. we'll create sub_model here just to show how..
// !but when you implement it.. create your model in 'models' folder
class _SubModel extends Equatable {
  final String value1;
  final String value2;

  const _SubModel({
    required this.value1,
    required this.value2,
  });

  @override
  List<Object> get props => [value1, value2];

  _SubModel copyWith({
    String? value1,
    String? value2,
  }) {
    return _SubModel(
      value1: value1 ?? this.value1,
      value2: value2 ?? this.value2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  Map<String, dynamic> toUpdateMap({
    FirestoreFieldUpdater<String>? value1,
    FirestoreFieldUpdater<String>? value2,
  }) {
    Map<String, dynamic> updateMap = {};

    if (value1 != null) updateMap['value1'] = value1.fieldValue;
    if (value2 != null) updateMap['value2'] = value2.fieldValue;

    return updateMap;
  }

  factory _SubModel.fromMap(Map<String, dynamic> map) {
    return _SubModel(
      value1: map['value1'] ?? '',
      value2: map['value2'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory _SubModel.fromJson(String source) =>
      _SubModel.fromMap(json.decode(source));

  @override
  String toString() => '_SubModel(value1: $value1, value2: $value2)';
}

//------------------------------------------------------------------------------//
//! Now let's implement SubRepository to show how it looks like..
class _SubRepository extends BaseFirestoreRepository<_SubModel> {
  _SubRepository()
      : super(
          fromMap: (map) => _SubModel.fromMap(map),
          toMap: (subModel) => subModel.toMap(),
        );

  @override
  //! This line should be the following commented call:
  // String get collectionPath => Config.subCollection;
  // And you need to define 'subCollection' in config file to make it work..
  // For now as it's explanation purpose gonne set just string
  String get collectionPath => 'collectionPath';
}

//! This is it.. the _SubRepository now can implement all the functions of BaseFirestoreRepository
// And now you can add extra functions to _SubRepository.. 
// Or override functions of baseFirestoreRepository inside subRepository...
// This will save you from repeating common functions for each repository..