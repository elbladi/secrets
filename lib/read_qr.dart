import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ReadQR extends StatefulWidget {
  const ReadQR({Key? key}) : super(key: key);

  @override
  State<ReadQR> createState() => _ReadQRState();
}

class _ReadQRState extends State<ReadQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(result!.code);
                      },
                      child: const Text('Scan completed'))
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }
}
