import 'package:flutter/material.dart';
import 'package:hr_pwa/features/auth/services/auth_gate.dart';
import 'package:hr_pwa/features/auth/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://bjktqwxvydafaksxmsof.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqa3Rxd3h2eWRhZmFrc3htc29mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQxNjQwNjgsImV4cCI6MjA1OTc0MDA2OH0.qDnM1ma--99pc40zB78gfuTaes4AK2bd6EwS9vMXpoo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
