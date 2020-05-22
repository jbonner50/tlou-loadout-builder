import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class MyLoadoutsModel extends ChangeNotifier {
  File jsonFile;
  var jsonFileContent = {};

  void updateJsonFileContent() {
    if (jsonFile.existsSync()) {
      jsonFileContent = json.decode(jsonFile.readAsStringSync());
    }
  }

  void addLoadout(String name, List loadout) async {
    var newLoadout = {name.toUpperCase(): loadout};
    if (jsonFile.existsSync()) {
      //add new loadout to file
      jsonFileContent.addAll(newLoadout);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
      updateJsonFileContent();
    } else {
      //create file and add new loadout as first entry
      jsonFile.createSync();
      jsonFile.writeAsStringSync(json.encode(newLoadout));
      updateJsonFileContent();
    }
    notifyListeners();
  }

  void removeLoadout(String name) async {
    if (jsonFile.existsSync()) {
      //add new loadout to file
      updateJsonFileContent();
      jsonFileContent.remove(name.toUpperCase());
      jsonFile.writeAsString(json.encode(jsonFileContent));
      notifyListeners();
    }
  }
}
