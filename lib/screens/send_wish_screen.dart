import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SendWishScreen extends StatefulWidget {
  final String receiverName;
  final String receiverUid;

  const SendWishScreen({
    super.key,
    required this.receiverName,
    required this.receiverUid,
  });

  @override
  State<SendWishScreen> createState() => _SendWishScreenState();
}

class _SendWishScreenState extends State<SendWishScreen> {
  final TextEditingController messageController = TextEditingController();

  bool isSending = false;

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

  Future<void> sendWish() async {
    try {
      setState(() {
        isSending = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final db = FirebaseDatabase.instanceFor(
        app: FirebaseAuth.instance.app,
        databaseURL:
            "https://avex-69c58-default-rtdb.asia-southeast1.firebasedatabase.app",
      );

      final points = respectPoints[selectedRespect] ?? 10;

      final wishRef = db.ref("wishes/${widget.receiverUid}").push();

      await wishRef.set({
        "senderUid": currentUser.uid,
        "senderName": currentUser.displayName ?? "User",
        "senderEmail": currentUser.email ?? "",
        "message": messageController.text.trim(),
        "respectTitle": selectedRespect,
        "respectPoints": points,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });

      final userSnapshot = await db.ref("users/${widget.receiverUid}").get();

      if (userSnapshot.exists) {
        final userData = Map<dynamic, dynamic>.from(userSnapshot.value as Map);

        final currentPoints = userData["withRespectPoints"] ?? 0;

        await db
            .ref("users/${widget.receiverUid}/withRespectPoints")
            .set(currentPoints + points);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wish sent with $selectedRespect 💜")),
      );

      Navigator.pop(context);
    } catch (e) {
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
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
                onPressed: isSending ? null : sendWish,
                child: isSending
                    ? const CircularProgressIndicator()
                    : const Text("SEND WISH", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
