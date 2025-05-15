// lib/services/mongo_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/plan_model.dart';
import 'gemini_service.dart';

class MongoService {
  // Because GeminiService.baseUrl is now a compile-time constant, we can also use const
  static const String baseUrl = GeminiService.baseUrl;

  /// Create (save) a new plan
  Future<PlanModel> createPlan(String prompt, String planText) async {
    final url = Uri.parse('$baseUrl/plans');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt, 'plan': planText}),
    );
    if (resp.statusCode == 200) {
      return PlanModel.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Failed to save plan: ${resp.body}');
  }

  /// Fetch all plans
  Future<List<PlanModel>> getAllPlans() async {
    final url = Uri.parse('$baseUrl/plans');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((j) => PlanModel.fromJson(j)).toList();
    }
    throw Exception('Failed to load plans');
  }

  /// Update by ID
  Future<PlanModel> updatePlan(String id, String newText) async {
    final url = Uri.parse('$baseUrl/plans/$id');
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'plan': newText}),
    );
    if (resp.statusCode == 200) {
      return PlanModel.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Failed to update plan');
  }

  /// Delete by ID
  Future<void> deletePlan(String id) async {
    final url = Uri.parse('$baseUrl/plans/$id');
    final resp = await http.delete(url);
    if (resp.statusCode != 200) {
      throw Exception('Failed to delete plan');
    }
  }
}
