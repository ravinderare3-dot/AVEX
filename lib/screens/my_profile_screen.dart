import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Map<dynamic, dynamic>? userData;

  bool isLoading = true;

  int wellWishersCount = 0;
  int wishesCount = 0;
  int respectScore = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final db = FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      );

      final snapshot = await db.ref("users/${user.uid}").get();

      int count = 0;

      final wellWishersSnapshot = await db.ref("wellwishers/${user.uid}").get();

      if (wellWishersSnapshot.exists) {
        final data = Map<dynamic, dynamic>.from(
          wellWishersSnapshot.value as Map,
        );

        count = data.length;
      }

      if (snapshot.exists) {
        setState(() {
          userData = snapshot.value as Map;

          wellWishersCount = count;

          wishesCount = 0;

          respectScore = count * 10;

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget statBox(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.purpleAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purpleAccent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.purple.shade700,
                        child: Text(
                          (userData?["profileName"] ?? "R")[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      userData?["profileName"] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "@${userData?["username"] ?? ""}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Card(
                      color: Colors.grey.shade900,
                      child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.purpleAccent,
                        ),
                        title: Text(
                          user?.email ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    Card(
                      color: Colors.grey.shade900,
                      child: ListTile(
                        leading: const Icon(
                          Icons.cake,
                          color: Colors.purpleAccent,
                        ),
                        title: Text(
                          "${userData?["birthdayMonth"] ?? ""} ${userData?["birthdayDay"] ?? ""}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        statBox(wellWishersCount.toString(), "WellWishers"),
                        statBox(wishesCount.toString(), "Wishes"),
                        statBox(respectScore.toString(), "Respect"),
                      ],
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Profile"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
