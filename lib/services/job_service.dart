import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/job_model.dart';

class JobService {
  static final Uri _jobsUri =
      Uri.parse('https://remotive.com/api/remote-jobs?limit=50');

  Future<List<Job>> fetchJobs() async {
    final response = await http
        .get(_jobsUri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 25));

    if (response.statusCode != 200) {
      throw Exception('The jobs service returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final rawJobs = decoded['jobs'];
    if (rawJobs is! List) {
      throw const FormatException('Unexpected response from the jobs service.');
    }

    return rawJobs
        .whereType<Map<String, dynamic>>()
        .map(Job.fromJson)
        .toList();
  }
}
