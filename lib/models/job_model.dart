
class Job {
  const Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.jobType,
    required this.description,
    required this.salary,
    required this.category,
    required this.url,
    this.companyWebsite = '',
    this.companyAddress = 'Not disclosed',
    this.city = '',
    this.state = '',
    this.area = '',
    this.stipend = 'Not disclosed',
    this.duration = 'Not specified',
    this.eligibility = 'Not specified',
    this.skills = '',
    this.companyLogoUrl = '',
    this.source = 'Local listing',
  });

  final int id;
  final String title;
  final String companyName;
  final String location;
  final String jobType;
  final String description;
  final String salary;
  final String category;
  final String url;

  final String companyWebsite;
  final String companyAddress;
  final String city;
  final String state;
  final String area;
  final String stipend;
  final String duration;
  final String eligibility;
  final String skills;
  final String companyLogoUrl;
  final String source;

  bool get isInternship =>
      jobType.toLowerCase().contains('intern');

  // Remotive API jobs
  factory Job.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString() ?? '';

    return Job(
      id: int.tryParse(rawId) ?? rawId.hashCode,
      title: _text(json['title'], 'Untitled role'),
      companyName: _text(
        json['company_name'],
        'Unknown company',
      ),
      location: _text(
        json['candidate_required_location'],
        'Not specified',
      ),
      jobType: _text(
        json['job_type'],
        'Not specified',
      ),
      description: _text(
        json['description'],
        'No description provided.',
      ),
      salary: _text(
        json['salary'],
        'Not disclosed',
      ),
      category: _text(
        json['category'],
        'Other',
      ),
      url: _text(json['url'], ''),
      companyLogoUrl: _text(
        json['company_logo'],
        '',
      ),
      source: 'Remotive',
    );
  }

  // Supabase Admin-added jobs
  factory Job.fromSupabaseJson(
    Map<String, dynamic> json,
  ) {
    final rawId = json['id']?.toString() ?? '';

    return Job(
      id: int.tryParse(rawId) ?? rawId.hashCode,
      title: _text(
        json['title'],
        'Untitled role',
      ),
      companyName: _text(
        json['company_name'],
        'Unknown company',
      ),
      location: _text(
        json['location'],
        'Not specified',
      ),
      jobType: _text(
        json['job_type'],
        'Not specified',
      ),
      description: _text(
        json['description'],
        'No description provided.',
      ),
      salary: _text(
        json['salary'],
        'Not disclosed',
      ),
      category: _text(
        json['category'],
        'Other',
      ),
      url: _text(
        json['apply_url'],
        '',
      ),
      source: 'Admin Added',
    );
  }

  // Adzuna API jobs
  factory Job.fromAdzunaJson(
    Map<String, dynamic> json,
  ) {
    final location = json['location'];
    final company = json['company'];

    final salaryMin = json['salary_min'];
    final salaryMax = json['salary_max'];

    String salary = 'Not disclosed';

    if (salaryMin != null && salaryMax != null) {
      salary = '₹$salaryMin - ₹$salaryMax';
    } else if (salaryMin != null) {
      salary = 'From ₹$salaryMin';
    }

    final rawId = json['id']?.toString() ?? '';

    return Job(
      id: int.tryParse(rawId) ?? rawId.hashCode,
      title: _text(
        json['title'],
        'Untitled role',
      ),
      companyName: company is Map
          ? _text(
              company['display_name'],
              'Unknown company',
            )
          : 'Unknown company',
      location: location is Map
          ? _text(
              location['display_name'],
              'Not specified',
            )
          : 'Not specified',
      jobType: _text(
        json['contract_time'],
        'Not specified',
      ),
      description: _text(
        json['description'],
        'No description provided.',
      ),
      salary: salary,
      category: json['category'] is Map
          ? _text(
              json['category']['label'],
              'Other',
            )
          : 'Other',
      url: _text(
        json['redirect_url'],
        '',
      ),
      source: 'Adzuna',
    );
  }

  static String _text(
    dynamic value,
    String fallback,
  ) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }
}
