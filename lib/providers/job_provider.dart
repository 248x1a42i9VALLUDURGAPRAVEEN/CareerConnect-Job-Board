import 'package:flutter/foundation.dart';

import '../models/job_model.dart';
import '../services/job_service.dart';

class JobProvider extends ChangeNotifier {
  JobProvider({JobService? service}) : _service = service ?? JobService();

  final JobService _service;
  List<Job> _jobs = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _locationFilter = '';
  String _typeFilter = '';

  List<Job> get jobs => List.unmodifiable(_jobs);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get locationFilter => _locationFilter;
  String get typeFilter => _typeFilter;

  List<Job> get visibleJobs {
    return _jobs.where((job) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          job.title.toLowerCase().contains(query) ||
          job.companyName.toLowerCase().contains(query) ||
          job.category.toLowerCase().contains(query);
      final matchesLocation = _locationFilter.isEmpty ||
          job.location.toLowerCase().contains(_locationFilter.toLowerCase());
      final matchesType = _typeFilter.isEmpty ||
          job.jobType.toLowerCase().contains(_typeFilter.toLowerCase());
      return matchesSearch && matchesLocation && matchesType;
    }).toList();
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _jobs = await _service.fetchJobs();
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value.trim();
    notifyListeners();
  }

  void setFilters({String location = '', String type = ''}) {
    _locationFilter = location.trim();
    _typeFilter = type.trim();
    notifyListeners();
  }

  void clearFilters() {
    _locationFilter = '';
    _typeFilter = '';
    notifyListeners();
  }
}
