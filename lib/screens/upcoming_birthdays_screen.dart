import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UpcomingBirthdaysScreen extends StatefulWidget {
  const UpcomingBirthdaysScreen({super.key});

  @override
  State<UpcomingBirthdaysScreen> createState() =>
      _UpcomingBirthdaysScreenState();
}

class _UpcomingBirthdaysScreenState extends State<UpcomingBirthdaysScreen> {
  List<Map<String, dynamic>> birthdays = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  int daysUntilBirthday(String monthName, String dayStr) {
    const months = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    final now = DateTime.now();

    int month = months[monthName] ?? 1;
    int day = int.tryParse(dayStr) ?? 1;

    DateTime birthday = DateTime(now.year, month, day);

    if (birthday.isBefore(now)) {
      birthday = DateTime(now.year + 1, month, day);
    }

    return birthday.difference(now).inDays + 1;
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

      List<Map<String, dynamic>> result = [];

      data.forEach((key, value) {
        final user = Map<String, dynamic>.from(value);

        final daysLeft = daysUntilBirthday(
          user["birthdayMonth"] ?? "",
          user["birthdayDay"].toString(),
        );

        user["daysLeft"] = daysLeft;

        result.add(user);
      });

      result.sort((a, b) => a["daysLeft"].compareTo(b["daysLeft"]));

      setState(() {
        birthdays = result;
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
        title: const Text("Upcoming Birthdays"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: birthdays.length,
              itemBuilder: (context, index) {
                final user = birthdays[index];

                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Icon(Icons.cake),
                    ),
                    title: Text(
                      user["profileName"] ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "@${user["username"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      "${user["daysLeft"]}d",
                      style: const TextStyle(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
