import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

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

      List<Map<String, dynamic>> users = [];

      data.forEach((key, value) {
        final user = Map<String, dynamic>.from(value);

        user["uid"] = key;

        if (currentUser != null && user["email"] != currentUser.email) {
          users.add(user);
        }
      });

      setState(() {
        allUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      print("Search Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendRequest(Map<String, dynamic> receiver) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final receiverUid = receiver["uid"].toString();

      await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("wellwisher_requests/$receiverUid/${currentUser.uid}").set({
        "senderUid": currentUser.uid,
        "senderName": currentUser.displayName ?? "User",
        "senderEmail": currentUser.email ?? "",
        "status": "pending",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WellWisher Request Sent 🤝")),
      );
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void searchUser(String query) {
    final results = allUsers.where((user) {
      final name = (user["profileName"] ?? "").toString().toLowerCase();

      final username = (user["username"] ?? "").toString().toLowerCase();

      return name.contains(query.toLowerCase()) ||
          username.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Search Users"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: searchUser,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search users...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(
                          child: Text(
                            "No users found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return Card(
                              color: Colors.grey.shade900,
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  user["profileName"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "@${user["username"]}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () => sendRequest(user),
                                  child: const Text("Add"),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
