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

  int withRespectPoints = 0;
  int withRespectPercent = 0;

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

      final profileSnapshot = await db.ref("users/${user.uid}").get();

      int wellWisherCount = 0;

      final wellWishersSnapshot = await db.ref("wellwishers/${user.uid}").get();

      if (wellWishersSnapshot.exists) {
        final data = Map<dynamic, dynamic>.from(
          wellWishersSnapshot.value as Map,
        );

        wellWisherCount = data.length;
      }

      int wishes = 0;

      final wishesSnapshot = await db.ref("wishes/${user.uid}").get();

      if (wishesSnapshot.exists) {
        final data = Map<dynamic, dynamic>.from(wishesSnapshot.value as Map);

        wishes = data.length;
      }

      if (profileSnapshot.exists) {
        final profile = Map<dynamic, dynamic>.from(
          profileSnapshot.value as Map,
        );

        final points = profile["withRespectPoints"] ?? 0;

        setState(() {
          userData = profile;

          wellWishersCount = wellWisherCount;

          wishesCount = wishes;

          withRespectPoints = points;

          withRespectPercent = points ~/ 260;

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
                        backgroundColor: Colors.purple,
                        child: Text(
                          (userData?["profileName"] ?? "R")[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
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

                    const SizedBox(height: 5),

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
                          userData?["email"] ?? "",
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

                        statBox("$withRespectPercent%", "With Respect"),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Card(
                      color: Colors.grey.shade900,
                      child: ListTile(
                        leading: const Icon(
                          Icons.workspace_premium,
                          color: Colors.amber,
                        ),
                        title: Text(
                          "$withRespectPercent%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          "With Respect",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
