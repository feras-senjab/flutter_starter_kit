// ignore_for_file: unused_element

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../config.dart';
import '../base_repository/base_repository.dart';

//------------------------------------------------------------------------------//
//! This file not to be used anywhere.. don't export it or use it..
//! it's just to explain how to extend base_repository with sub_repository.
// We have base_repository that implements most common CRUD operations.
// And we can make sub_repositroy like the following to extend the base_repository
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
class _SubRepository extends BaseRepository<_SubModel> {
  // Determine the deployment environment to specify in which collection to make operations (test / production.. or maybe other in future..)
  // ! Take a look to config file.. where you have also to determine collectionPath
  final DeploymentEnv deploymentEnv;
  _SubRepository({required this.deploymentEnv})
      : super(
          fromMap: (map) => _SubModel.fromMap(map),
          toMap: (subModel) => subModel.toMap(),
        );

  @override
  //! This line should be the following commented call:
  // String get collectionPath => Config(deploymentEnv: deploymentEnv).subCollection;
  // And you need to define 'subCollection' im config file to make it work..
  // For now as it's explanation purpose gonne set just string
  String get collectionPath => 'collectionPath';
}

//! This is it.. the _SubRepository now can implement all the functions of BaseRepository
// And now you can add extra functions to _SubRepository.. 
// Or override a functions of baseRepository inside subRepository...
// This will save you from repeating common functions for each repository..
