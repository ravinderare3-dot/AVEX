import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WellWisherRequestsScreen extends StatefulWidget {
  const WellWisherRequestsScreen({super.key});

  @override
  State<WellWisherRequestsScreen> createState() =>
      _WellWisherRequestsScreenState();
}

class _WellWisherRequestsScreenState extends State<WellWisherRequestsScreen> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final snapshot = await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("wellwisher_requests/${currentUser.uid}").get();

      if (!snapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      List<Map<String, dynamic>> loaded = [];

      data.forEach((key, value) {
        final request = Map<String, dynamic>.from(value);

        loaded.add(request);
      });

      setState(() {
        requests = loaded;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> acceptRequest(Map<String, dynamic> request) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final senderUid = request["senderUid"].toString();

      final db = FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      );

      await db.ref("wellwishers/${currentUser.uid}/$senderUid").set(true);

      await db.ref("wellwishers/$senderUid/${currentUser.uid}").set(true);

      await db
          .ref("wellwisher_requests/${currentUser.uid}/$senderUid")
          .remove();

      loadRequests();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WellWisher Added Successfully 🤝")),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> rejectRequest(Map<String, dynamic> request) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final senderUid = request["senderUid"].toString();

      await FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("wellwisher_requests/${currentUser.uid}/$senderUid").remove();

      loadRequests();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Request Rejected")));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("WellWisher Requests"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(
              child: Text(
                "No Pending Requests 🤝",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            request["senderName"] ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            request["senderEmail"] ?? "",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => acceptRequest(request),
                              child: const Text("Accept"),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () => rejectRequest(request),
                              child: const Text("Reject"),
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
