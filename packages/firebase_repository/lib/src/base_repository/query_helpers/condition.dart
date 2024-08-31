import 'package:cloud_firestore/cloud_firestore.dart';

enum ConditionOperator {
  isEqualTo,
  isNotEqualTo,
  isGreaterThan,
  isLessThan,
  arrayContains,
}

class Condition {
  final String field;
  final ConditionOperator operator;
  final dynamic value;

  Condition({
    required this.field,
    required this.operator,
    required this.value,
  });

  // Apply this condition to a Firestore query
  Query apply(Query query) {
    switch (operator) {
      case ConditionOperator.isEqualTo:
        return query.where(field, isEqualTo: value);
      case ConditionOperator.isNotEqualTo:
        return query.where(field, isNotEqualTo: value);
      case ConditionOperator.isGreaterThan:
        return query.where(field, isGreaterThan: value);
      case ConditionOperator.isLessThan:
        return query.where(field, isLessThan: value);
      case ConditionOperator.arrayContains:
        return query.where(field, arrayContains: value);
      default:
        throw Exception('Unsupported condition operator: $operator');
    }
  }
}
