
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/job_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const Color blue = Color(0xFF1565C0);
  static const Color purple = Color(0xFF7B1FA2);
  static const Color teal = Color(0xFF00897B);
  static const Color orange = Color(0xFFFF9800);

  late final TextEditingController _locationController;
  late String _type;

  @override
  void initState() {
    super.initState();

    final provider = context.read<JobProvider>();

    _locationController =
        TextEditingController(text: provider.locationFilter);

    _type = provider.typeFilter;
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      fillColor: const Color(0xFFF5F3FF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE0D7F5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: purple,
          width: 2,
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF292044),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text(
          'Filter Jobs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [blue, purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [blue, purple],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: purple.withOpacity(0.22),
                    blurRadius: 15,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Find Your Perfect Job!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Choose your preferences to discover suitable opportunities.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Filter Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: purple.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  _sectionTitle(
                    'Location',
                    Icons.location_on_rounded,
                    blue,
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: _locationController,
                    decoration: _inputDecoration(
                      hint: 'Example: India, USA, Worldwide',
                      icon: Icons.map_outlined,
                      iconColor: blue,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Job Type
                  _sectionTitle(
                    'Job Type',
                    Icons.work_rounded,
                    purple,
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    isExpanded: true,
                    decoration: _inputDecoration(
                      hint: 'Select job type',
                      icon: Icons.business_center_rounded,
                      iconColor: purple,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: '',
                        child: Text('Any Type'),
                      ),
                      DropdownMenuItem(
                        value: 'full_time',
                        child: Text('Full Time'),
                      ),
                      DropdownMenuItem(
                        value: 'part_time',
                        child: Text('Part Time'),
                      ),
                      DropdownMenuItem(
                        value: 'contract',
                        child: Text('Contract'),
                      ),
                      DropdownMenuItem(
                        value: 'freelance',
                        child: Text('Freelance'),
                      ),
                      DropdownMenuItem(
                        value: 'internship',
                        child: Text('Internship'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _type = value ?? '';
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  // Information
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: teal,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Select your preferred location and job type to filter available jobs.',
                            style: TextStyle(
                              color: Color(0xFF00695C),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Clear Filters Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _locationController.clear();
                    _type = '';
                  });

                  context.read<JobProvider>().clearFilters();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Clear All Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: purple,
                  side: const BorderSide(
                    color: purple,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Apply Filters Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [blue, purple],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: blue.withOpacity(0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<JobProvider>().setFilters(
                          location: _locationController.text,
                          type: _type,
                        );

                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
