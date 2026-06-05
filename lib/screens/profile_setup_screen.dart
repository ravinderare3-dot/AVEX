import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  String month = "January";
  String day = "1";

  bool isLoading = false;

  Future<void> saveProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("users/${user.uid}").set({
        "profileName": nameController.text.trim(),

        "username": usernameController.text.trim(),

        "birthdayMonth": month,

        "birthdayDay": day,

        "email": user.email ?? "",

        "photoUrl": user.photoURL ?? "",

        "createdAt": DateTime.now().toIso8601String(),

        // AVEX With Respect System
        "withRespectPoints": 0,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Complete Profile"),
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Profile Name",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: month,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: const [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() {
                  month = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: day,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: List.generate(
                31,
                (index) => DropdownMenuItem(
                  value: "${index + 1}",
                  child: Text("${index + 1}"),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  day = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProfile,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Continue", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
