import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:secret/model/accounts.dart';
import 'package:secret/utilities.dart';

import 'actions/colors.dart';
import 'actions/store.dart';

class MyCard extends StatefulWidget {
  final Account _account;
  final int _index;
  const MyCard(this._account, this._index, {Key? key}) : super(key: key);

  @override
  State<MyCard> createState() => _CardState();
}

class _CardState extends State<MyCard> {
  late TextEditingController _controller;
  late TextEditingController _controllerMail;
  bool _editable = false;
  bool _loading = false;
  late String _oldVal;
  late String _oldValMail;
  @override
  void initState() {
    _controller = TextEditingController(text: widget._account.password);
    _controllerMail = TextEditingController(text: widget._account.email);
    _oldVal = _controller.text;
    _oldValMail = _controllerMail.text;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerMail.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _controller.text.trim())).then((_) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Copy 🤫",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  void _expansionChanged(bool opened) {
    if (!opened && _editable) {
      if (_oldVal == _controller.text) {
        setState(() => _editable = false);
        return;
      }
      // ignore: avoid_single_cascade_in_expression_statements
      AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          headerAnimationLoop: true,
          animType: AnimType.SCALE,
          title: "¿Guardar cambios?",
          btnOkText: "Ok",
          btnCancelText: "Cancelar",
          btnOkOnPress: () {
            setState(() {
              _oldVal = _controller.text;
              _oldValMail = _controllerMail.text;
            });
          },
          btnCancelColor: const Color.fromRGBO(163, 196, 243, 1),
          buttonsTextStyle: const TextStyle(fontSize: 15),
          btnOkColor: Colors.blue[400],
          btnCancelOnPress: () {
            if (_oldVal != _controller.text) {
              _controller.text = _oldVal;
              _controllerMail.text = _oldValMail;
            }
            setState(() => _editable = false);
          },
          onDissmissCallback: (type) {})
        ..show();
    }
  }

  void _editRecords() {
    setState(() => _editable = true);
  }

  Future<void> _saveChanges() async {
    try {
      setState(() => _loading = true);
      Account account = Account()
        ..app = widget._account.app
        ..email = _controllerMail.text
        ..password = _controller.text;
      if (isTheSame(account, widget._index)) {
        setState(() {
          _editable = false;
          _loading = false;
        });
        return;
      }

      await updateAccount(account, widget._index);
      setState(() {
        _oldVal = _controller.text;
        _oldValMail = _controllerMail.text;
        _editable = false;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Algo salio mal 😪",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: orangeLight,
      collapsedIconColor: pinkStrong,
      textColor: Colors.red,
      title: Text(widget._account.app.capitalize()),
      leading: getImage(widget._account, _loading),
      subtitle: Text(
        _controllerMail.text,
        style: const TextStyle(
          color: pinkStrong,
        ),
      ),
      onExpansionChanged: _expansionChanged,
      children: [
        ListTile(
          title: _editable
              ? TextField(
                  controller: _controller,
                )
              : Text(_controller.text),
          leading: IconButton(
            icon: _editable ? const Icon(Icons.save) : const Icon(Icons.edit),
            onPressed: _editable
                ? _loading
                    ? null
                    : _saveChanges
                : _editRecords,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.copy_rounded,
              color: _editable ? Colors.grey : Colors.black,
            ),
            onPressed: _editable ? null : _copyToClipboard,
          ),
        ),
        _editable
            ? ListTile(
                trailing: const Icon(Icons.email),
                leading: const SizedBox(width: 35),
                title: TextField(controller: _controllerMail),
              )
            : const SizedBox(),
      ],
    );
  }
}
