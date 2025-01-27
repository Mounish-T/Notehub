import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../toast.dart';
import 'change_password.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  Future<void> _changePassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    showCustomToast(context, "Successfully logged out ", user?.displayName ?? "");
  }

  Future<void> _deleteAccount() async {
    try {
      await user?.delete();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      showCustomToast(context, "Successfully deleted User ", user?.displayName ?? "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showCustomToast(context, "Please re-login and try again", "");
      } else {
        showCustomToast(context, "Error: ${e.message}", "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: const Color.fromARGB(255, 117, 182, 214),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${user?.displayName ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 123, 229, 183),
              ),
            ),
          ],
        ),
      ),
    );
  }
}