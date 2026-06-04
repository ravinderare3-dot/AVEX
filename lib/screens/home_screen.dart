import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'my_profile_screen.dart';
import 'todays_birthdays_screen.dart';

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

              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
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

            _buildTile(context, Icons.cake, "Today's Birthdays"),

            _buildTile(context, Icons.calendar_month, "Upcoming Birthdays"),

            _buildTile(context, Icons.favorite, "Well Wishes"),

            _buildTile(context, Icons.people, "WellWishers"),

            _buildTile(context, Icons.star, "Respect Meter"),

            _buildTile(context, Icons.card_giftcard, "Advance Wishes"),

            _buildTile(context, Icons.celebration, "Celebrity Birthdays"),

            _buildTile(context, Icons.person, "My Profile"),

            _buildTile(context, Icons.search, "Search Users"),

            _buildTile(context, Icons.notifications, "Notifications"),

            _buildTile(context, Icons.settings, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title) {
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
        onTap: () {
          if (title == "My Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyProfileScreen()),
            );
          } else if (title == "Today's Birthdays") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TodaysBirthdaysScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$title feature coming soon 🚀")),
            );
          }
        },
      ),
    );
  }
}
