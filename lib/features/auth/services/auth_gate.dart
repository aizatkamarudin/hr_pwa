import 'package:flutter/material.dart';
import 'package:hr_pwa/features/auth/signin.dart';
import 'package:hr_pwa/features/home/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            return HomeScreen();
          } else {
            return SignInScreen();
          }
        });
  }
}
