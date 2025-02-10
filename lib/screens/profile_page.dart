import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();

  User? get currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _usernameController.text = currentUser?.displayName ?? '';
  }

  Future<void> _updateUsername() async {
    try {
      String newUsername = _usernameController.text.trim();
      if (newUsername.isEmpty) {
        Fluttertoast.showToast(msg: 'Username cannot be empty');
        return;
      }

      await currentUser?.updateDisplayName(newUsername);
      await currentUser?.reload();
      setState(() {}); 
      Fluttertoast.showToast(msg: 'Username updated successfully!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUsername,
                style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD8900A),
  ),
              child: const Text('Update Username'),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Username: ${currentUser?.displayName ?? 'No username set'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
