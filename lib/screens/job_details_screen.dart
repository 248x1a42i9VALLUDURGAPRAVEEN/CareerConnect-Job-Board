import 'package:flutter/material.dart';

import '../models/job_model.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFE9EEFC),
            child: Text(
              job.companyName.isNotEmpty ? job.companyName[0].toUpperCase() : '?',
              style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF3157A4),
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(job.title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(job.companyName,
              style: const TextStyle(fontSize: 17, color: Colors.blueGrey)),
          const SizedBox(height: 18),
          _info(Icons.location_on_outlined, 'Location', job.location),
          _info(Icons.work_outline, 'Job type', job.jobType),
          _info(Icons.category_outlined, 'Category', job.category),
          _info(Icons.payments_outlined, 'Salary', job.salary),
          const SizedBox(height: 20),
          const Text('Job description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // The API supplies HTML-formatted descriptions. Strip tags for a
          // simple readable beginner version.
          Text(
            job.description.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(
                RegExp(r'&nbsp;|&amp;|&quot;|&#39;'), ' '),
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ApplyScreen(job: job)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Text('Apply for this job'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Note: This demo records your application details only on this screen. '
            'It does not send them to the employer. Use the original job link '
            'from the job listing to apply with the employer.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF3157A4)),
          const SizedBox(width: 10),
          Expanded(
            child: Text('$label: $value',
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
