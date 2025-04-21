import 'package:ecommerceapp/screens/loginpage.dart';
import 'package:ecommerceapp/screens/orderhistorypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not signed in")),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.displayName ?? 'No Name',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email ?? 'No Email',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("My Orders"),
            onTap: () {
               Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderHistoryPage()),
                          );
            }, // implement navigation
          ),
        
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Logout"),
            onTap: () {
              _signOut(context);
            }, // implement navigation
          ),
        ],
      ),
    );
    
  }  Future<void> _signOut(BuildContext context) async {
    await GoogleSignIn().signOut(); // Sign out from Google
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase
    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          ); // Or navigate to login screen
  }
}