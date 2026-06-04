import 'package:flutter/material.dart';

class WellWisherRequestsScreen extends StatefulWidget {
  const WellWisherRequestsScreen({super.key});

  @override
  State<WellWisherRequestsScreen> createState() =>
      _WellWisherRequestsScreenState();
}

class _WellWisherRequestsScreenState extends State<WellWisherRequestsScreen> {
  final List<Map<String, String>> requests = [
    {"name": "Ravinder", "username": "ravinder03"},
    {"name": "Shanker", "username": "shanker01"},
  ];

  void acceptRequest(int index) {
    setState(() {
      requests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("WellWisher Request Accepted 🎉")),
    );
  }

  void rejectRequest(int index) {
    setState(() {
      requests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("WellWisher Request Rejected")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("WellWisher Requests"),
        backgroundColor: Colors.black,
      ),
      body: requests.isEmpty
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
                            request["name"]!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "@${request["username"]}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => acceptRequest(index),
                              child: const Text("Accept"),
                            ),

                            const SizedBox(width: 10),

                            OutlinedButton(
                              onPressed: () => rejectRequest(index),
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
