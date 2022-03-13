import 'package:flutter/material.dart';
import 'package:secret/actions/colors.dart';
import 'package:secret/actions/login.dart';
import 'content_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LloginScreenState();
}

class LloginScreenState extends State<LoginScreen> {
  void _initLogin() async {
    if (await login()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContentBody()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[purpleLight, blueLight, blue1, blue2, orangeLight],
          ),
        ),
        child: Center(
          child: InkWell(
            onTap: _initLogin,
            child: const Text("🔐", style: TextStyle(fontSize: 30)),
          ),
        ),
      ),
    );
  }
}
