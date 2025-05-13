import 'package:flutter/foundation.dart';

class Patient {
  final String name;
  final int age;
  final String? strokeType;
  final DateTime? onsetDate;

  Patient({
    required this.name,
    required this.age,
    this.strokeType,
    this.onsetDate,
  });

  /// Deserialize from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'] as String,
      age: json['age'] as int,
      strokeType: json['strokeType'] as String?,
      onsetDate:
          json['onsetDate'] != null
              ? DateTime.parse(json['onsetDate'] as String)
              : null,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'name': name, 'age': age};
    if (strokeType != null) {
      map['strokeType'] = strokeType;
    }
    if (onsetDate != null) {
      map['onsetDate'] = onsetDate!.toIso8601String();
    }
    return map;
  }
}
