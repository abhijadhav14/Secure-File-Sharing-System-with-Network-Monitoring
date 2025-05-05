import 'package:flutter/material.dart';
import 'login_page.dart';
import '../services/api_service.dart';

class SignupPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _signup(BuildContext context) async {
    final success = await ApiService.signup(
      usernameController.text,
      passwordController.text,
    );
    if (success != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Column(
        children: [
          TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
          TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
          ElevatedButton(onPressed: () => _signup(context), child: Text("Signup")),
        ],
      ),
    );
  }
}
