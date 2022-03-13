import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:secret/actions/colors.dart';

class QRScreen extends StatelessWidget {
  final String content;
  const QRScreen(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🤫", style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: content,
              version: QrVersions.auto,
              size: 300.0,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
