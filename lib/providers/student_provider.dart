
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/job_model.dart';

class StudentProfile {
  final String studentName;
  final String email;
  final String phone;
  final String collegeName;
  final String university;
  final String rollNumber;
  final String course;
  final String branch;
  final String currentYear;
  final String graduationYear;
  final String skills;
  final String preferredJobRole;
  final String resumeUrl;

  StudentProfile({
    required this.studentName,
    required this.email,
    required this.phone,
    required this.collegeName,
    required this.university,
    required this.rollNumber,
    required this.course,
    required this.branch,
    required this.currentYear,
    required this.graduationYear,
    required this.skills,
    required this.preferredJobRole,
    required this.resumeUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'email': email,
      'phone': phone,
      'collegeName': collegeName,
      'university': university,
      'rollNumber': rollNumber,
      'course': course,
      'branch': branch,
      'currentYear': currentYear,
      'graduationYear': graduationYear,
      'skills': skills,
      'preferredJobRole': preferredJobRole,
      'resumeUrl': resumeUrl,
    };
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      studentName: json['studentName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      collegeName: json['collegeName'] ?? '',
      university: json['university'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      course: json['course'] ?? '',
      branch: json['branch'] ?? '',
      currentYear: json['currentYear'] ?? '',
      graduationYear: json['graduationYear'] ?? '',
      skills: json['skills'] ?? '',
      preferredJobRole: json['preferredJobRole'] ?? '',
      resumeUrl: json['resumeUrl'] ?? '',
    );
  }
}

class AppliedJob {
  final String jobId;
  final String title;
  final String companyName;
  final String location;
  final String jobType;
  final DateTime appliedAt;

  AppliedJob({
    required this.jobId,
    required this.title,
    required this.companyName,
    required this.location,
    required this.jobType,
    required this.appliedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'title': title,
      'companyName': companyName,
      'location': location,
      'jobType': jobType,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }

  factory AppliedJob.fromJson(Map<String, dynamic> json) {
    return AppliedJob(
      jobId: json['jobId'] ?? '',
      title: json['title'] ?? '',
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
      jobType: json['jobType'] ?? '',
      appliedAt: DateTime.tryParse(json['appliedAt'] ?? '') ??
          DateTime.now(),
    );
  }
}

class StudentProvider extends ChangeNotifier {
  StudentProfile? _student;

  final List<AppliedJob> _applications = [];

  StudentProfile? get student => _student;

  bool get hasProfile => _student != null;

  List<AppliedJob> get applications =>
      List.unmodifiable(_applications);

  // Load saved student profile and application history
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final profileData = prefs.getString('student_profile');

    if (profileData != null) {
      _student = StudentProfile.fromJson(
        jsonDecode(profileData),
      );
    }

    final applicationData =
        prefs.getString('student_applications');

    if (applicationData != null) {
      final List<dynamic> decoded =
          jsonDecode(applicationData);

      _applications
        ..clear()
        ..addAll(
          decoded.map(
            (item) => AppliedJob.fromJson(
              Map<String, dynamic>.from(item),
            ),
          ),
        );
    }

    notifyListeners();
  }

  // Save student profile
  Future<void> saveStudent(StudentProfile profile) async {
    final prefs = await SharedPreferences.getInstance();

    final saved = await prefs.setString(
      'student_profile',
      jsonEncode(profile.toJson()),
    );

    if (!saved) {
      throw Exception('Student profile could not be saved.');
    }

    _student = profile;
    notifyListeners();
  }

  // Check whether student already applied
  bool hasApplied(String jobId) {
    return _applications.any(
      (application) => application.jobId == jobId,
    );
  }

  // Add application and save it on this device
  Future<bool> addApplication(Job job) async {
    final jobId = job.id.toString();

    if (hasApplied(jobId)) {
      return false;
    }

    final application = AppliedJob(
      jobId: jobId,
      title: job.title,
      companyName: job.companyName,
      location: job.location,
      jobType: job.jobType,
      appliedAt: DateTime.now(),
    );

    final updatedApplications = [
      ..._applications,
      application,
    ];

    final prefs = await SharedPreferences.getInstance();

    final saved = await prefs.setString(
      'student_applications',
      jsonEncode(
        updatedApplications
            .map((item) => item.toJson())
            .toList(),
      ),
    );

    if (!saved) {
      throw Exception('Application could not be saved.');
    }

    _applications.add(application);
    notifyListeners();

    return true;
  }

  // Clear student profile only
  Future<void> clearStudent() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('student_profile');

    _student = null;
    notifyListeners();
  }
}
