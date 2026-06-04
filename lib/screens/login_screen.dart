import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_setup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.purpleAccent,
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                "AVEX",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Every Wish Matters",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Continue with Google"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () async {
                  final user = await AuthService().signInWithGoogle();

                  if (user != null) {
                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileSetupScreen(),
                      ),
                    );
                  } else {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Google Login Failed")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
