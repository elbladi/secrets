import 'package:flutter/material.dart';

List<String> _options = [
  "Amazon",
  "Facebook",
  "Instagram",
  "AT&T",
  "Banamex",
  "Bancoppel",
  "Bizworks",
  "CFE",
  "Coppel",
  "Crypto",
  "Discord",
  "Disney",
  "Exodus",
  "Gmail",
  "HBO",
  "InDriver",
  "Life360",
  "LinkedIn",
  "Mercado Libre",
  "Mercado Pago",
  "Netflix",
  "Paramount",
  "Pinterest",
  "Prime",
  "Rappi",
  "Spotify",
  "Star+",
  "Teams",
  "TikTok",
  "Twitter",
  "Uber",
  "UpSiVale",
  "Volaris",
  "Yeedi",
  "YouTube"
];

class OptionsModal extends StatelessWidget {
  const OptionsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 300,
      child: Center(
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 25,
          mainAxisSpacing: 10,
          children: _options.map((e) => Option(e)).toList(),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final List<String> _exceptions = const ["Mercado Libre", "Mercado Pago"];
  final String option;
  const Option(this.option, {Key? key}) : super(key: key);

  String _getAssetName() {
    var name = option.toLowerCase();
    if (_exceptions.contains(option)) {
      switch (option) {
        case "Mercado Libre":
          name = "mercado_libre";
          break;
        case "Mercado Pago":
          name = "mercado_pago";
          break;
      }
    }
    return 'assets/$name.png';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(option);
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(_getAssetName()),
      ),
    );
  }
}
