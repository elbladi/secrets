import 'dart:io';

import 'package:flutter/material.dart';
import 'package:secret/model/accounts.dart';

Widget getImage(Account account, bool loading) {
  if (account.isFromAssets) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: loading
          ? const CircularProgressIndicator()
          : Image.asset(
              account.imagePath,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text(
                  "😥",
                  style: TextStyle(fontSize: 30),
                );
              },
            ),
    );
  } else {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(File(account.imagePath)),
        child: loading ? const CircularProgressIndicator() : null);
  }
}
