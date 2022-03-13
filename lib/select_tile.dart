import 'package:flutter/material.dart';
import 'package:secret/actions/store.dart';
import 'package:secret/model/accounts.dart';
import 'package:secret/utilities.dart';

import 'actions/colors.dart';

class SelectTile extends StatelessWidget {
  final Account account;
  final Function _updateShare;
  final int index;
  final bool _selected;
  const SelectTile(this.account, this._updateShare, this.index, this._selected,
      {Key? key})
      : super(key: key);

  void _toggleSelect() {
    _updateShare(!_selected, index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: _selected,
      onTap: _toggleSelect,
      selectedTileColor: Colors.red,
      selectedColor: Colors.red,
      leading: getImage(account, false),
      title: Text(account.app.capitalize()),
      subtitle: Text(
        account.email,
        style: const TextStyle(
          color: pinkStrong,
        ),
      ),
      trailing: IconButton(
          onPressed: _toggleSelect,
          icon: _selected
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank_rounded)),
    );
  }
}
