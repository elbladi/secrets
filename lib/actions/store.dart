import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:secret/actions/handle_file.dart';
import 'package:secret/model/accounts.dart';

// ignore: constant_identifier_names
const AccountsBox = "accounts";

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

Box<Account> get _getBox => Hive.box<Account>(AccountsBox);
Box<Account> get getBox => _getBox;

Future<List<Account>> loadAccountsFromDB() async {
  try {
    final box = _getBox;
    if (!box.isOpen) await Hive.openBox<Account>(AccountsBox);
    await Future.delayed(const Duration(milliseconds: 700));
    return List.from(box.values);
  } catch (e) {
    rethrow;
  }
}

Future<void> updateAccount(Account account, int index) async {
  try {
    final box = _getBox;
    if (!box.isOpen) await Hive.openBox<Account>(AccountsBox);
    final storedAcc = box.get(index);
    if (storedAcc == null) throw "Not found";
    storedAcc.email = account.email;
    storedAcc.password = account.password;
    await storedAcc.save();
    await Future.delayed(const Duration(milliseconds: 500));
  } catch (e) {
    rethrow;
  }
}

bool isTheSame(Account account, int index) {
  final box = _getBox;
  final storedAcc = box.get(index);
  if (storedAcc == null) return false;
  return storedAcc.email == account.email &&
      storedAcc.password == account.password;
}

Future<void> addNewAccount(String app, String email, String pwd, bool fromFile,
    String imagePath) async {
  try {
    var newPath = imagePath;
    if (fromFile) {
      newPath = await moveFile(File(imagePath), app);
    }
    Account account = Account()
      ..app = app
      ..email = email
      ..password = pwd
      ..isFromAssets = !fromFile
      ..imagePath = newPath;
    final box = _getBox;
    await box.add(account);
  } catch (e) {
    rethrow;
  }
}

Future<void> validateNewAcc(String appName) async {
  try {
    final box = _getBox;
    List<Account> accounts = List.from(box.values);
    final index = accounts
        .indexWhere((acc) => acc.app.toLowerCase() == appName.toLowerCase());
    if (index != -1) {
      await Future.delayed(const Duration(milliseconds: 800));
      throw "App Already exist";
    }
  } catch (e) {
    rethrow;
  }
}

Future<bool> removeAcc(int index, Account account) async {
  try {
    if (!account.isFromAssets) {
      await deleteFile(account.imagePath);
    }

    final box = _getBox;
    final acc = box.getAt(index);
    if (acc == null) return false;
    await acc.delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<String> generateQR(List<String> ids) async {
  try {
    final box = _getBox;
    List<Account> lista = List.empty(growable: true);
    for (var id in ids) {
      final account = box.get(int.parse(id));
      if (account != null) lista.add(account);
    }
    return jsonEncode(lista);
  } catch (e) {
    return "";
  }
}

List<String> getIds() {
  final box = _getBox;
  return box.keys.map((k) => (k as int).toString()).toList();
}

Future<void> processQR(String data) async {
  try {
    final list = jsonDecode(data) as List<dynamic>;
    List<Account> newAcc = List.empty(growable: true);
    for (var i in list) {
      newAcc.add(Account().fromJson(i));
    }

    for (var account in newAcc) {
      try {
        await validateNewAcc(account.app);
        await addNewAccount(
          account.app,
          account.email,
          account.password,
          false,
          account.imagePath,
        );
      } catch (e) {
        logError(e);
      }
    }
  } catch (e) {
    logError(e);
  }
}

List<Account> loadAccs() {
  return List.from(_getBox.values);
}

//TODO: Remove this code
// Future<void> removeAll() async {
//   final box = _getBox;
//   // final keys = box.deleteAll(box.keys);
//   box.keys.forEach((e) {
//   });
// }

