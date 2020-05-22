import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/my_loadouts_model.dart';
import 'package:tlou_loadout/services/loadout_card.dart';

class MyLoadouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget noSavedLoadouts() {
      return Center(
          child: Text(
        'No Saved Loadouts',
        style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
      ));
    }

    return Consumer<MyLoadoutsModel>(
      builder: (context, myLoadoutsModel, child) {
        if (myLoadoutsModel.jsonFile != null) {
          if (myLoadoutsModel.jsonFile.existsSync()) {
            List loadouts = myLoadoutsModel.jsonFileContent.entries.toList();
            if (loadouts.length != 0) {
              return Container(
                child: ListView.builder(
                  itemCount: loadouts.length,
                  itemBuilder: (context, index) {
                    return LoadoutCard(
                      name: loadouts[index].key,
                      loadout: loadouts[index].value,
                    );
                    // return Row(
                    //   children: [
                    //     Text(loadouts[index].key),
                    //     IconButton(
                    //       icon: Icon(Icons.delete),
                    //       onPressed: () {
                    //         Provider.of<MyLoadoutsModel>(context,
                    //                 listen: false)
                    //             .removeLoadout(loadouts[index].key);
                    //       },
                    //     ),
                    //   ],
                    // );
                  },
                ),
              );
            } else {
              return noSavedLoadouts();
            }
          } else {
            return noSavedLoadouts();
          }
        } else {
          return noSavedLoadouts();
        }
      },
    );
  }
}
