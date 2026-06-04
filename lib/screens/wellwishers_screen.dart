import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WellWishersScreen extends StatefulWidget {
  const WellWishersScreen({super.key});

  @override
  State<WellWishersScreen> createState() => _WellWishersScreenState();
}

class _WellWishersScreenState extends State<WellWishersScreen> {
  List<String> wellWishers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWellWishers();
  }

  Future<void> loadWellWishers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final snapshot = await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("wellwishers/${currentUser.uid}").get();

      if (!snapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      List<String> users = [];

      data.forEach((key, value) {
        users.add(key.toString());
      });

      setState(() {
        wellWishers = users;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("WellWishers"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wellWishers.isEmpty
          ? const Center(
              child: Text(
                "No WellWishers Yet 🤝",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: wellWishers.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.people)),
                    title: Text(
                      wellWishers[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
