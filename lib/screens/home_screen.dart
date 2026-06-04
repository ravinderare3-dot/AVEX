import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("AVEX"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),

              const SizedBox(height: 15),

              Text(
                "Welcome ${user?.displayName ?? 'User'} 👋",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              _buildTile(Icons.cake, "Today's Birthdays"),

              _buildTile(Icons.calendar_month, "Upcoming Birthdays"),

              _buildTile(Icons.favorite, "Well Wishes"),

              _buildTile(Icons.star, "Respect Meter"),

              _buildTile(Icons.card_giftcard, "Advance Wishes"),

              _buildTile(Icons.person, "My Profile"),

              _buildTile(Icons.celebration, "Celebrity Birthdays"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.purpleAccent),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
      ),
    );
  }
}
