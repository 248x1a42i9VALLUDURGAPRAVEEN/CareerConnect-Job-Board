
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/job_provider.dart';
import '../services/auth_service.dart';
import '../widgets/job_card.dart';
import 'filter_screen.dart';
import 'job_details_screen.dart';
import 'student_registration_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color blue = Color(0xFF1565C0);
  static const Color purple = Color(0xFF7B1FA2);
  static const Color background = Color(0xFFF5F3FF);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HomeScreen.purple,
              foregroundColor: Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JobProvider>();

    return Scaffold(
      backgroundColor: HomeScreen.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: HomeScreen.purple,
        title: Row(
          children: [
            Image.asset(
              'assets/images/careerconnect_logo.png',
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 9),
            const Text(
              'CareerConnect',
              style: TextStyle(
                color: HomeScreen.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Student Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const StudentRegistrationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.account_circle_rounded),
            color: HomeScreen.blue,
          ),
          IconButton(
            tooltip: 'Filter jobs',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FilterScreen(),
                ),
              );
            },
            icon: const Icon(Icons.tune_rounded),
            color: HomeScreen.purple,
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded),
            color: Colors.red,
          ),
          const SizedBox(width: 5),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Welcome Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 15, 16, 18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      HomeScreen.blue,
                      Color(0xFF512DA8),
                      HomeScreen.purple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: HomeScreen.purple
                          .withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Student! 👋',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            'Find Your Dream Job',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Explore opportunities and build your future.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.work_outline_rounded,
                      color: Colors.white,
                      size: 65,
                    ),
                  ],
                ),
              ),
            ),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: HomeScreen.purple
                          .withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context
                        .read<JobProvider>()
                        .setSearchQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText:
                        'Search jobs, companies or skills',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: HomeScreen.blue,
                      size: 27,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: HomeScreen.purple,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<JobProvider>()
                            .setSearchQuery('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                  ),
                ),
              ),
            ),

            // Explore Jobs Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  18, 22, 18, 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          HomeScreen.blue,
                          HomeScreen.purple,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.explore_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Jobs',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF512DA8),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Discover your next career opportunity',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${provider.visibleJobs.length} Jobs',
                      style: const TextStyle(
                        color: Color(0xFF512DA8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Job List
            Expanded(
              child: _jobContent(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobContent(
      BuildContext context, JobProvider provider) {

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: HomeScreen.purple,
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 55,
                color: HomeScreen.purple,
              ),
              const SizedBox(height: 14),
              const Text(
                'Could not load jobs',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: provider.loadJobs,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.visibleJobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 60,
                color: HomeScreen.purple,
              ),
              const SizedBox(height: 14),
              const Text(
                'No Jobs Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HomeScreen.purple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try another search or clear your filters.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  provider.setSearchQuery('');
                  provider.clearFilters();
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                    'Clear Search and Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: HomeScreen.purple,
      onRefresh: provider.loadJobs,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
            16, 4, 16, 20),
        itemCount: provider.visibleJobs.length,
        itemBuilder: (context, index) {
          final job = provider.visibleJobs[index];

          return JobCard(
            job: job,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      JobDetailsScreen(job: job),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
