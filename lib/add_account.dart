import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secret/actions/colors.dart';
import 'package:secret/options.dart';
import 'package:rive/rive.dart';
import 'actions/store.dart';

class MyImage {
  bool fromFile;
  String path;

  MyImage({required this.fromFile, required this.path});
}

class AddAccount extends StatefulWidget {
  const AddAccount({Key? key}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final TextEditingController _email = TextEditingController(text: "");
  final TextEditingController _pwsd = TextEditingController(text: "");
  final TextEditingController _app = TextEditingController(text: "");
  late bool _lock;
  late int _seconds;
  late bool _loading;
  late bool _error;
  late MyImage? _image;

  @override
  void initState() {
    _loading = false;
    _seconds = 2;
    _error = false;
    _lock = false;
    _image = null;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _app.dispose();
    _pwsd.dispose();

    super.dispose();
  }

  bool get disableButton =>
      _app.text.isEmpty ||
      _email.text.isEmpty ||
      _pwsd.text.isEmpty ||
      _image == null;

  void _validate() async {
    if (_app.text.isEmpty && _email.text.isEmpty && _pwsd.text.isEmpty) {
      Navigator.of(context).pop();
    }
    try {
      await validateNewAcc(_app.text);
    } catch (e) {
      _cancelSave();
      setState(() => _error = true);
    }
  }

  Future<void> _setCounter() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_seconds == 0) {
      await addNewAccount(
          _app.text, _email.text, _pwsd.text, _image!.fromFile, _image!.path);
      Navigator.of(context).pop();
    } else {
      if (_loading) {
        setState(() => _seconds -= 1);
        _setCounter();
      }
    }
  }

  void _cancelSave() {
    setState(() {
      _loading = false;
      _seconds = 3;
    });
  }

  void _onChanged(String _val) {
    if (!_error) return;
    setState(() => _error = false);
  }

  Widget getRow(
    IconData icon,
    TextEditingController ctl,
    bool error,
    bool fromAppName,
    String hint,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: pinkStrong),
        const SizedBox(width: 10),
        Expanded(
            child: TextField(
          enabled: fromAppName ? (fromAppName && !_lock) : true,
          controller: ctl,
          onChanged: fromAppName ? _onChanged : null,
          enableSuggestions: true,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: error ? Colors.red : purpleStrong,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            hintText: hint,
          ),
        )),
        fromAppName && _lock
            ? IconButton(
                icon: const Icon(Icons.remove_circle, color: pinkStrong),
                onPressed: () {
                  _app.text = "";
                  setState(() {
                    _lock = false;
                    _image = null;
                  });
                },
              )
            : const SizedBox(),
      ],
    );
  }

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;
    setState(() {
      _image = MyImage(fromFile: true, path: image.path);
    });
  }

  void _showOptions(BuildContext ctx) async {
    final val = await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: const Center(
                  child: Text("✨", style: TextStyle(fontSize: 30))),
              content: const OptionsModal(),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: ctx,
      pageBuilder: (context, animation1, animation2) => const SizedBox(),
    );

    if (val != null) {
      _app.text = val as String;
      setState(() {
        _lock = true;
        _image =
            MyImage(fromFile: false, path: 'assets/${val.toLowerCase()}.png');
      });
    }
  }

  Widget showThisImage() {
    if (_image == null) {
      return const CircleAvatar(backgroundColor: purpleLight, radius: 70);
    }
    if (_image!.fromFile) {
      return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 70,
        backgroundImage: FileImage(File(_image!.path)),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 70,
        backgroundImage: AssetImage(_image!.path),
      );
    }
  }

  void _onSave() async {
    if (!_loading) {
      setState(() => _loading = true);
      _validate();
      await _setCounter();
    } else {
      _cancelSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: blue1,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: 400,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: _selectImage,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: pinkStrong,
                      radius: 72,
                      child: showThisImage(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showOptions(context),
                  child: const SizedBox(
                    height: 28,
                    width: 28,
                    child: RiveAnimation.asset(
                      "assets/white_background.riv",
                    ),
                  ),
                ),
              ],
            ),
            getRow(Icons.movie_creation_outlined, _app, _error, true, "App"),
            getRow(Icons.email, _email, false, false, "email/user"),
            getRow(Icons.lock, _pwsd, false, false, "password"),
            Center(
              child: ElevatedButton.icon(
                onPressed: disableButton ? null : _onSave,
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: pinkStrong,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label:
                    _loading ? Text("Cancelar($_seconds)") : const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
