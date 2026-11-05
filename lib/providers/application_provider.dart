
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationProvider extends ChangeNotifier {
  List<int> _appliedJobIds = [];

  List<int> get appliedJobIds => List.unmodifiable(_appliedJobIds);

  bool isApplied(int jobId) {
    return _appliedJobIds.contains(jobId);
  }

  Future<void> loadApplications() async {
    final prefs = await SharedPreferences.getInstance();
    _appliedJobIds = prefs.getStringList('applied_jobs')
            ?.map((id) => int.tryParse(id) ?? 0)
            .where((id) => id != 0)
            .toList() ??
        [];
    notifyListeners();
  }

  Future<void> applyForJob(int jobId) async {
    if (_appliedJobIds.contains(jobId)) return;

    _appliedJobIds.add(jobId);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'applied_jobs',
      _appliedJobIds.map((id) => id.toString()).toList(),
    );

    notifyListeners();
  }
}
