import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'notes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Login failed: ${e.toString()}")),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF6A1B9A);
    final backgroundColor = Color(0xFFF3E5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: _login,
              child: Text("Login", style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text("Don't have an account? Sign up"),
            )
          ],
        ),
      ),
    );
  }
}
