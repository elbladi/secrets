import 'package:flutter/material.dart';
import 'package:secret/actions/colors.dart';
import 'package:secret/actions/login.dart';
import 'content_body.dart';

class LoginScreen extends StatelessWidget {
  void _initLogin(BuildContext context) async {
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
          child: FutureBuilder(
            future: canUseBiometrics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: Colors.red);
              }

              if (snapshot.data == null) {
                return Text("Necesitas habilitar biometricos");
              }

              bool canUseBiometric = snapshot.data!;
              if (!canUseBiometric)
                return Text("Necesitas habilitar biometricos");

              return InkWell(
                onTap: () => _initLogin(context),
                child: const Text("🔐", style: TextStyle(fontSize: 30)),
              );
            },
          ),
        ),
      ),
    );
  }
}
