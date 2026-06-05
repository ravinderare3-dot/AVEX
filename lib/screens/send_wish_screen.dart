import 'package:flutter/material.dart';

class SendWishScreen extends StatefulWidget {
  final String receiverName;

  const SendWishScreen({super.key, required this.receiverName});

  @override
  State<SendWishScreen> createState() => _SendWishScreenState();
}

class _SendWishScreenState extends State<SendWishScreen> {
  final TextEditingController messageController = TextEditingController();

  String selectedRespect = "Friend";

  final Map<String, int> respectPoints = {
    "Friend": 10,
    "Close Friend": 25,
    "Special Friend": 50,
    "Best WellWisher": 75,
    "Legendary Respect": 100,
  };

  @override
  void initState() {
    super.initState();

    messageController.text = "Happy Birthday 🎂🎉";
  }

  Widget respectTile(String title, String emoji) {
    return Card(
      color: selectedRespect == title
          ? Colors.purple.shade700
          : Colors.grey.shade900,
      child: RadioListTile<String>(
        value: title,
        groupValue: selectedRespect,
        activeColor: Colors.white,
        title: Text(
          "$emoji $title",
          style: const TextStyle(color: Colors.white),
        ),
        onChanged: (value) {
          setState(() {
            selectedRespect = value!;
          });
        },
      ),
    );
  }

  void sendWish() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wish sent with $selectedRespect 💜")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Send Wish"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🎂 To: ${widget.receiverName}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Message",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: messageController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "With Respect",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            respectTile("Friend", "🤝"),

            respectTile("Close Friend", "💜"),

            respectTile("Special Friend", "🌟"),

            respectTile("Best WellWisher", "🔥"),

            respectTile("Legendary Respect", "👑"),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: sendWish,
                child: const Text("SEND WISH", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
