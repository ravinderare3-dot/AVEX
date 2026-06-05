import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'todays_birthdays_screen.dart';
import 'upcoming_birthdays_screen.dart';
import 'search_users_screen.dart';
import 'wellwisher_requests_screen.dart';
import 'wellwishers_screen.dart';
import 'received_wishes_screen.dart';
import 'my_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int withRespectPercent = 0;

  @override
  void initState() {
    super.initState();
    loadRespect();
  }

  Future<void> loadRespect() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final snapshot = await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("users/${user.uid}").get();

      if (snapshot.exists) {
        final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

        final points = data["withRespectPoints"] ?? 0;

        setState(() {
          withRespectPercent = points ~/ 260;
        });
      }
    } catch (e) {
      print(e);
    }
  }

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
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
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

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "⭐ With Respect",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "$withRespectPercent%",
                    style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _buildTile(context, Icons.cake, "Today's Birthdays"),

            _buildTile(context, Icons.calendar_month, "Upcoming Birthdays"),

            _buildTile(context, Icons.search, "Search Users"),

            _buildTile(context, Icons.person_add, "WellWisher Requests"),

            _buildTile(context, Icons.people, "WellWishers"),

            _buildTile(context, Icons.mail, "Received Wishes"),

            _buildTile(context, Icons.favorite, "Well Wishes"),

            _buildTile(context, Icons.card_giftcard, "Advance Wishes"),

            _buildTile(context, Icons.celebration, "Celebrity Birthdays"),

            _buildTile(context, Icons.notifications, "Notifications"),

            _buildTile(context, Icons.settings, "Settings"),

            _buildTile(context, Icons.person, "My Profile"),
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
          if (title == "Today's Birthdays") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TodaysBirthdaysScreen()),
            );
          } else if (title == "Upcoming Birthdays") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UpcomingBirthdaysScreen(),
              ),
            );
          } else if (title == "Search Users") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchUsersScreen()),
            );
          } else if (title == "WellWisher Requests") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WellWisherRequestsScreen(),
              ),
            );
          } else if (title == "WellWishers") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WellWishersScreen()),
            );
          } else if (title == "Received Wishes") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReceivedWishesScreen()),
            );
          } else if (title == "My Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyProfileScreen()),
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
