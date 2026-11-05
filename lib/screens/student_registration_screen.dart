
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState
    extends State<StudentRegistrationScreen> {
  static const Color blue = Color(0xFF1565C0);
  static const Color purple = Color(0xFF7B1FA2);
  static const Color background = Color(0xFFF5F3FF);

  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _college = TextEditingController();
  final _university = TextEditingController();
  final _rollNumber = TextEditingController();
  final _course = TextEditingController();
  final _branch = TextEditingController();
  final _currentYear = TextEditingController();
  final _graduationYear = TextEditingController();
  final _skills = TextEditingController();
  final _jobRole = TextEditingController();
  final _resumeUrl = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final profile = context.read<StudentProvider>().student;

    if (profile != null) {
      _name.text = profile.studentName;
      _email.text = profile.email;
      _phone.text = profile.phone;
      _college.text = profile.collegeName;
      _university.text = profile.university;
      _rollNumber.text = profile.rollNumber;
      _course.text = profile.course;
      _branch.text = profile.branch;
      _currentYear.text = profile.currentYear;
      _graduationYear.text = profile.graduationYear;
      _skills.text = profile.skills;
      _jobRole.text = profile.preferredJobRole;
      _resumeUrl.text = profile.resumeUrl;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _college.dispose();
    _university.dispose();
    _rollNumber.dispose();
    _course.dispose();
    _branch.dispose();
    _currentYear.dispose();
    _graduationYear.dispose();
    _skills.dispose();
    _jobRole.dispose();
    _resumeUrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final profile = StudentProfile(
        studentName: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        collegeName: _college.text.trim(),
        university: _university.text.trim(),
        rollNumber: _rollNumber.text.trim(),
        course: _course.text.trim(),
        branch: _branch.text.trim(),
        currentYear: _currentYear.text.trim(),
        graduationYear: _graduationYear.text.trim(),
        skills: _skills.text.trim(),
        preferredJobRole: _jobRole.text.trim(),
        resumeUrl: _resumeUrl.text.trim(),
      );

      await context.read<StudentProvider>().saveStudent(profile);

      if (!mounted) return;

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save profile: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _header(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, top: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [blue, purple],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 23),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = true,
    IconData icon = Icons.edit_outlined,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: blue),
          filled: true,
          fillColor: const Color(0xFFF7F5FF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE0D7F5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: purple,
              width: 1.7,
            ),
          ),
        ),
        validator: (value) {
          if (required &&
              (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }

          if (label == 'Email' &&
              value != null &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                  .hasMatch(value.trim())) {
            return 'Enter a valid email';
          }

          return null;
        },
      ),
    );
  }

  Widget _profileItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: blue, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 115,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: const TextStyle(color: Color(0xFF424242)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  Widget _myApplications(StudentProvider provider) {
    final applications = provider.applications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header('My Applications', Icons.work_history_rounded),

        if (applications.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.work_outline_rounded,
                  size: 45,
                  color: purple,
                ),
                SizedBox(height: 10),
                Text(
                  'No applications yet.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Jobs you apply for will appear here.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...applications.reversed.map((application) {
            return Card(
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(application.companyName),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: blue,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(application.location)),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline,
                          color: purple,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(application.jobType)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Applied on: ${_formatDate(application.appliedAt)}',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Status: Applied',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _profileCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          const Divider(height: 22),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfile(StudentProvider provider, StudentProfile profile) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Student Profile'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [blue, purple],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [blue, purple],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    profile.email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _profileCard('Personal Details', [
              _profileItem('Email', profile.email, Icons.email_outlined),
              _profileItem('Phone', profile.phone, Icons.phone_outlined),
            ]),

            _profileCard('College Details', [
              _profileItem('College', profile.collegeName, Icons.school),
              _profileItem('University', profile.university, Icons.account_balance),
              _profileItem('Roll Number', profile.rollNumber, Icons.badge),
              _profileItem('Course', profile.course, Icons.menu_book),
              _profileItem('Branch', profile.branch, Icons.category),
              _profileItem('Current Year', profile.currentYear, Icons.calendar_today),
              _profileItem('Graduation Year', profile.graduationYear, Icons.event),
            ]),

            _profileCard('Career Details', [
              _profileItem('Skills', profile.skills, Icons.star_outline),
              _profileItem('Preferred Role', profile.preferredJobRole, Icons.work),
              _profileItem('Resume URL', profile.resumeUrl, Icons.description),
            ]),

            _myApplications(provider),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [blue, purple],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final profile = provider.student;

    if (profile != null && !_isEditing) {
      return _buildProfile(provider, profile);
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          profile == null ? 'Student Registration' : 'Edit Profile',
        ),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [blue, purple],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [blue, purple],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(height: 9),
                  Text(
                    'Complete Your Student Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add your details to explore career opportunities.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _header('Personal Details', Icons.person_outline),
            _field(
              'Student Name',
              _name,
              icon: Icons.person,
            ),
            _field(
              'Email',
              _email,
              keyboardType: TextInputType.emailAddress,
              icon: Icons.email_outlined,
            ),
            _field(
              'Phone',
              _phone,
              keyboardType: TextInputType.phone,
              icon: Icons.phone_outlined,
            ),

            _header('College Details', Icons.school_outlined),
            _field('College Name', _college, icon: Icons.apartment),
            _field('University', _university, icon: Icons.account_balance),
            _field('Roll Number', _rollNumber, icon: Icons.badge),
            _field('Course', _course, icon: Icons.menu_book),
            _field('Branch', _branch, icon: Icons.category),
            _field('Current Year', _currentYear, icon: Icons.calendar_today),
            _field('Graduation Year', _graduationYear, icon: Icons.event),

            _header('Career Details', Icons.work_outline),
            _field(
              'Skills',
              _skills,
              maxLines: 2,
              icon: Icons.star_outline,
            ),
            _field(
              'Preferred Job Role',
              _jobRole,
              icon: Icons.work,
            ),
            _field(
              'Resume URL (Optional)',
              _resumeUrl,
              keyboardType: TextInputType.url,
              required: false,
              icon: Icons.description_outlined,
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [blue, purple],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _isSaving ? 'Saving...' : 'Save Profile',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
