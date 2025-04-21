import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSigningIn = false;



Future<void> addStaticProductsOnce() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final userSnapshot = await userDoc.get();

  // If products are already added, return
  if (userSnapshot.exists && userSnapshot.data()?['productsAdded'] == true) {
    print('Products already added');
    return;
  }

  // List of static products
  final products = [
    {'name': 'Aloe Vera', 'price': 99, 'image': 'https://m.media-amazon.com/images/I/61vM5XmrW2L._AC_UF1000,1000_QL80_.jpg'},
    {'name': 'Snake Plant', 'price': 120, 'image': 'https://m.media-amazon.com/images/I/711plKZuarL._AC_UF1000,1000_QL80_.jpg'},
    {'name': 'Peace Lily', 'price': 150, 'image': 'https://m.media-amazon.com/images/I/51VU7-hQWiL.jpg'},
    {'name': 'Areca Palm', 'price': 180, 'image': 'https://images.thdstatic.com/productImages/4c0de9fb-0cdf-4d64-b19f-d87ebc07138d/svn/stylewell-artificial-trees-t4446-64_600.jpg'},
    {'name': 'Money Plant', 'price': 90, 'image': 'https://images.herzindagi.info/image/2021/Dec/how-to-grow-a-money-plant-at-home.jpg'},
    {'name': 'Spider Plant', 'price': 110, 'image': 'https://images.herzindagi.info/image/2021/Dec/spider-plant-benefits-for-health.jpg'},
    {'name': 'Jade Plant', 'price': 130, 'image': 'https://royalsplant.com/wp-content/uploads/2023/10/Jade-1.jpg'},

  ];

  final productCollection = FirebaseFirestore.instance
      .collection('ecomapp')
      .doc('products')
      .collection('items');

  for (var product in products) {
    final docRef = await productCollection.add(product);
    await docRef.update({'id': docRef.id}); // Add the generated ID as a field
  }

  // Set the flag in user's document
  await userDoc.set({'productsAdded': true}, SetOptions(merge: true));

  print('Products added successfully with IDs');
}



  Future<void> signInWithGoogle() async {
    try {
      setState(() {
        isSigningIn = true;
      });

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          isSigningIn = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isSigningIn = false;
      });

Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${userCredential.user?.displayName}!')),
      );
    } catch (e) {
      setState(() {
        isSigningIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }
@override
  void initState() {
addStaticProductsOnce();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: isSigningIn
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: signInWithGoogle,
              ),
      ),
    );
  }
}
