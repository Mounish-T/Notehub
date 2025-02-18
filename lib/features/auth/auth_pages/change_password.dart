import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../toast.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;

  Future<void> _changePassword() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _validatePassword = true;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _validateConfirmPassword = true;
      });
      return;
    }

    try {
      await _auth.currentUser?.updatePassword(_passwordController.text);
      analytics.logEvent(name: 'Password_changed', parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      });
      showCustomToast(context, "Password changed successfully", "");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showCustomToast(context, "Error: ${e.message}", "");
    }
  }

  @override
  void initState() {
    _logChangePasswordPageVisit();
    super.initState();
  }

  Future<void> _logChangePasswordPageVisit() async {
    analytics.logEvent(name: 'change_password_page', parameters: {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: const Color.fromARGB(255, 117, 182, 214),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                errorText:
                    _validatePassword ? 'Password cannot be empty' : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                errorText:
                    _validateConfirmPassword ? 'Passwords do not match' : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
