import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:secret/actions/colors.dart';
import 'package:secret/actions/store.dart';
import 'package:secret/add_account.dart';
import 'package:secret/model/accounts.dart';
import 'package:secret/my_card.dart';
import 'package:secret/select_tile.dart';

class ContentBody extends StatefulWidget {
  const ContentBody({Key? key}) : super(key: key);

  @override
  State<ContentBody> createState() => _ContentBodyState();
}

class _ContentBodyState extends State<ContentBody> {
  late bool _shareMode;
  late List<String> _ids;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    _shareMode = false;
    _ids = List.empty(growable: true);
    super.initState();
  }

  void _showModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return const AddAccount();
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, int i, Account acc) async {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      headerAnimationLoop: true,
      animType: AnimType.scale,
      title: 'Eliminar ${acc.app.capitalize()}?',
      btnOkText: "Ok",
      btnCancelText: "Cancelar",
      btnOkOnPress: () async {
        await removeAcc(i, acc);
      },
      btnCancelColor: blueLight,
      buttonsTextStyle: const TextStyle(
        fontSize: 15,
        color: yellowLight,
      ),
      onDismissCallback: (type) {},
      btnOkColor: Colors.blue[400],
      btnCancelOnPress: () => false,
    )..show();
    return null;
  }

  void _onSelected(bool add, String id) {
    final temp = [..._ids];
    if (add) {
      temp.add(id);
    } else {
      temp.removeWhere((e) => e == id);
    }
    setState(() => _ids = temp);
  }

  bool get allSelected => loadAccs().length == _ids.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🤫", style: TextStyle(fontSize: 30)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showModal(context),
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 30,
          ),
        ],
      ),
      body: Container(
        color: blueLight,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ValueListenableBuilder(
            valueListenable: getBox.listenable(),
            builder: (context, Box<Account> box, _) {
              List<Account> accounts = List.from(box.values);
              accounts.sort((a, b) => a.app.compareTo(b.app));
              return ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (ctx, i) {
                    final id = box.keys.toList()[i];
                    if (_shareMode) {
                      return SelectTile(accounts[i], _onSelected, id,
                          _ids.contains(id.toString()));
                    }
                    return Dismissible(
                      key: Key(accounts[i].app),
                      confirmDismiss: (_) =>
                          _confirmDelete(context, i, accounts[i]),
                      background: Container(color: pinkStrong),
                      child: MyCard(accounts[i], id),
                    );
                  });
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: blue1,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.share_rounded, color: purpleStrong),
            label: 'Share',
          ),
          const BottomNavigationBarItem(
            icon: Text("🤫", style: TextStyle(fontSize: 25)),
            label: 'Add Secret',
          ),
          BottomNavigationBarItem(
            icon: _shareMode
                ? allSelected
                    ? const Icon(Icons.check_box_outline_blank_rounded)
                    : const Icon(Icons.check_box)
                : const Icon(Icons.camera_alt_rounded, color: purpleStrong),
            label: _shareMode
                ? allSelected
                    ? "Deselect all"
                    : "Select all"
                : "QR",
          ),
        ],
        currentIndex: 1,
        selectedItemColor: pinkStrong,
        onTap: (i) {
          if (i == 1) {
            _showModal(context);
          }
        },
      ),
    );
  }
}
