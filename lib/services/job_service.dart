
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/job_model.dart';

class JobService {
  static final Uri _jobsUri = Uri.parse(
    'https://remotive.com/api/remote-jobs?limit=50',
  );

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Job>> fetchJobs() async {
    final List<Job> allJobs = [];

    String? supabaseError;
    String? apiError;

    // 1. Fetch Admin-added jobs from Supabase
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .order('created_at', ascending: false);

      final supabaseJobs = (response as List)
          .whereType<Map<String, dynamic>>()
          .map(Job.fromSupabaseJson)
          .toList();

      allJobs.addAll(supabaseJobs);
    } catch (error) {
      supabaseError = error.toString();
    }

    // 2. Fetch online jobs from Remotive API
    try {
      final response = await http
          .get(
            _jobsUri,
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode != 200) {
        throw Exception(
          'Remotive returned status code ${response.statusCode}.',
        );
      }

      final decoded =
          jsonDecode(response.body) as Map<String, dynamic>;

      final rawJobs = decoded['jobs'];

      if (rawJobs is! List) {
        throw const FormatException(
          'Unexpected response from Remotive API.',
        );
      }

      final apiJobs = rawJobs
          .whereType<Map<String, dynamic>>()
          .map(Job.fromJson)
          .toList();

      allJobs.addAll(apiJobs);
    } catch (error) {
      apiError = error.toString();
    }

    // 3. Throw error only when both sources fail
    if (allJobs.isEmpty &&
        supabaseError != null &&
        apiError != null) {
      throw Exception(
        'Unable to load jobs.\n'
        'Supabase error: $supabaseError\n'
        'API error: $apiError',
      );
    }

    return allJobs;
  }
}
