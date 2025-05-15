// lib/models/plan_model.dart

class PlanModel {
  final String id;
  final String prompt;
  final String plan;
  final String createdAt;

  PlanModel({
    required this.id,
    required this.prompt,
    required this.plan,
    required this.createdAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['_id'] as String, // from Mongo _id
      prompt: json['prompt'] as String,
      plan: json['plan'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
