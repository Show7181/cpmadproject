import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyDrawer extends StatelessWidget {
  
  final Function(BuildContext, int, String) onTap;

  const MyDrawer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Guest';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFD8900A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'Welcome, $displayName!',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
               
                Text(
                  user?.email ?? 'Not logged in',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          // Drawer items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => onTap(context, 0, 'Home'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => onTap(context, 1, 'Profile'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Contact'),
            onTap: () => onTap(context, 2, 'Contact'),
          ),
            ListTile(
            leading: const Icon(Icons.book),
            title: const Text('History'),
            onTap: () => onTap(context, 3, 'History'),
          ),
        ],
      ),
    );
  }
}
