import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReceivedWishesScreen extends StatefulWidget {
  const ReceivedWishesScreen({super.key});

  @override
  State<ReceivedWishesScreen> createState() => _ReceivedWishesScreenState();
}

class _ReceivedWishesScreenState extends State<ReceivedWishesScreen> {
  List<Map<String, dynamic>> wishes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWishes();
  }

  Future<void> loadWishes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final snapshot = await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("wishes/${user.uid}").get();

      if (!snapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      List<Map<String, dynamic>> loaded = [];

      data.forEach((key, value) {
        final wish = Map<String, dynamic>.from(value);

        loaded.add(wish);
      });

      loaded = loaded.reversed.toList();

      setState(() {
        wishes = loaded;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  IconData getRespectIcon(String respect) {
    switch (respect) {
      case "Close Friend":
        return Icons.favorite;

      case "Special Friend":
        return Icons.star;

      case "Best WellWisher":
        return Icons.local_fire_department;

      case "Legendary Respect":
        return Icons.workspace_premium;

      default:
        return Icons.handshake;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Received Wishes"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishes.isEmpty
          ? const Center(
              child: Text(
                "No Wishes Yet 🎂",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: wishes.length,
              itemBuilder: (context, index) {
                final wish = wishes[index];

                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🎂 Birthday Wish",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          wish["message"] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "From: ${wish["senderName"] ?? "Unknown"}",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              getRespectIcon(wish["respectTitle"] ?? "Friend"),
                              color: Colors.purpleAccent,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              wish["respectTitle"] ?? "Friend",
                              style: const TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
