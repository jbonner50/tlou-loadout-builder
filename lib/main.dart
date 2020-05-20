import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/app.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/my_loadouts_model.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyLoadoutsModel()),
          ChangeNotifierProvider(create: (context) => LoadoutModel()),
        ],
        child: LoadoutManager(),
      ),
    );

class LoadoutManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> loadJsonData() async {
      String jsonText = await rootBundle.loadString('data/weapons_skills.json');
      Provider.of<LoadoutModel>(context, listen: false).data =
          json.decode(jsonText);
    }

    loadJsonData();
    return MaterialApp(
      home: App(),
      theme: ThemeData(
        fontFamily: 'TLOU',
        accentColor: Color.fromARGB(255, 234, 234, 219),
      ),
    );
  }
}
