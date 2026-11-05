
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/job_model.dart';
import '../providers/student_provider.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key, required this.job});

  final Job job;

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _coverController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final studentProvider = context.read<StudentProvider>();

    // Check whether the student already applied.
    if (studentProvider.hasApplied(widget.job.id.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already applied for this job!'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Save application in StudentProvider.
      final success =
          await studentProvider.addApplication(widget.job);

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already applied for this job!'),
          ),
        );
        return;
      }

      // Show success message.
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Application Submitted!'),
          content: Text(
            'Thank you, ${_nameController.text.trim()}!\n\n'
            'Your application for ${widget.job.title} '
            'has been added to My Applications in your Student Profile.\n\n'
            'Note: This is a demo application. '
            'It has not been sent to the employer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      // Return to the previous screen.
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save application: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.job.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              widget.job.companyName,
              style: const TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 22),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return 'Enter your full name (at least 2 characters).';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';

                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(email)) {
                  return 'Enter a valid email address.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                final phone =
                    value?.replaceAll(RegExp(r'\D'), '') ?? '';

                if (phone.length < 10 || phone.length > 15) {
                  return 'Enter a phone number with 10–15 digits.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _coverController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Why are you suitable for this job?',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().length < 20) {
                  return 'Write at least 20 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit Application'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Note: This is a demo application. '
              'Your application is recorded in the app, '
              'but it is not sent to the employer.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
