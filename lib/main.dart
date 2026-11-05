
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/job_provider.dart';
import 'providers/student_provider.dart';
import 'providers/application_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ybgumbzndrjjacozfwpm.supabase.co',
    publishableKey: 'sb_publishable_V8-Uhk02D2epVZA4ZXUtmQ_kMhiNjw1',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => JobProvider()..loadJobs(),
        ),
        ChangeNotifierProvider(
          create: (_) => StudentProvider()..loadData(),
        ),
        ChangeNotifierProvider(
          create: (_) => ApplicationProvider()..loadApplications(),
        ),
      ],
      child: const JobBoardApp(),
    ),
  );
}

class JobBoardApp extends StatelessWidget {
  const JobBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerConnect',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF00897B),
          surface: const Color(0xFFFFFFFF),
        ),

        scaffoldBackgroundColor: const Color(0xFFF8F7F5),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171717),
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFD7CCC8),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFD7CCC8),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF1565C0),
              width: 2,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Color(0xFF171717),
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Color(0xFF3E2723),
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF333333),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF5D4037),
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
