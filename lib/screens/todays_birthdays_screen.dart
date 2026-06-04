import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TodaysBirthdaysScreen extends StatefulWidget {
  const TodaysBirthdaysScreen({super.key});

  @override
  State<TodaysBirthdaysScreen> createState() => _TodaysBirthdaysScreenState();
}

class _TodaysBirthdaysScreenState extends State<TodaysBirthdaysScreen> {
  List<Map<String, dynamic>> birthdayUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  Future<void> loadBirthdays() async {
    try {
      final snapshot = await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("users").get();

      if (!snapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      final now = DateTime.now();

      const months = {
        1: "January",
        2: "February",
        3: "March",
        4: "April",
        5: "May",
        6: "June",
        7: "July",
        8: "August",
        9: "September",
        10: "October",
        11: "November",
        12: "December",
      };

      String currentMonth = months[now.month]!;
      String currentDay = now.day.toString();

      List<Map<String, dynamic>> results = [];

      data.forEach((key, value) {
        final user = Map<String, dynamic>.from(value);

        if (user["birthdayMonth"] == currentMonth &&
            user["birthdayDay"].toString() == currentDay) {
          results.add(user);
        }
      });

      setState(() {
        birthdayUsers = results;
        isLoading = false;
      });
    } catch (e) {
      print("Birthday Error: $e");

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
        title: const Text("Today's Birthdays"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : birthdayUsers.isEmpty
          ? const Center(
              child: Text(
                "No Birthdays Today 🎂",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: birthdayUsers.length,
              itemBuilder: (context, index) {
                final user = birthdayUsers[index];

                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Icon(Icons.cake, color: Colors.white),
                    ),
                    title: Text(
                      user["profileName"] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "@${user["username"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
