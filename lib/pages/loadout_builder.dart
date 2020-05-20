import 'package:tlou_loadout/services/slot_card.dart';
import 'package:flutter/material.dart';

class LoadoutBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get json weapon and skills data

// create list of loadout slot widgets
    List<Widget> loadoutWidgets = [];
    int actualSlot = 0;
    for (int slot = 0; slot < 9; slot++) {
      if (slot == 2 || slot == 7) {
        loadoutWidgets.add(Divider(
          thickness: 2,
          color: Theme.of(context).accentColor,
        ));
      } else {
        loadoutWidgets.add(SlotCard(
          slot: actualSlot,
        ));
        actualSlot++;
      }
    }

    //int trueIndex = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: loadoutWidgets,
      ),
    );
  }
}
