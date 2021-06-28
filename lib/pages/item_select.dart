import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/services/item_card.dart';

class ItemSelect extends StatelessWidget {
  final int slot;

  ItemSelect({this.slot});

  @override
  Widget build(BuildContext context) {
    List skillsAlreadyEquipped =
        Provider.of<LoadoutModel>(context, listen: false)
            .skillsEquippedDifferentSlots(slot);
    String currentItemEquipped =
        Provider.of<LoadoutModel>(context, listen: false)
            .itemEquippedSameSlot(slot);

    return Consumer<LoadoutModel>(
      builder: (context, loadoutModel, child) {
        final List itemList = loadoutModel.getList(slot);

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              bottom: PreferredSize(
                  child: Container(
                    color: Theme.of(context).accentColor,
                    height: 2,
                  ),
                  preferredSize: Size.fromHeight(4.0)),
              backgroundColor: Colors.black45,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (() {
                    switch (slot) {
                      case 0:
                        return 'Small Firearms';
                        break;
                      case 1:
                        return 'Large Firearms';
                        break;
                      case 6:
                        return 'Purchasables';
                        break;
                      default:
                        return 'Skills';
                    }
                  }()),
                  style: TextStyle(
                      fontSize: 25, color: Theme.of(context).accentColor),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    backgroundColor: Theme.of(context).accentColor,
                    label: Consumer<LoadoutModel>(
                      builder: (context, loadoutModel, child) => Text(
                        '${loadoutModel.points} / 13',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: loadoutModel.points == 0
                              ? Colors.redAccent[700]
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  skillsAlreadyEquipped: skillsAlreadyEquipped,
                  currentItemEquipped: currentItemEquipped,
                  item: itemList[index],
                  slot: slot,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
