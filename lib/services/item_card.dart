import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/pages/item_info.dart';

class ItemCard extends StatelessWidget {
  final Map item;
  final int slot;
  final List skillsAlreadyEquipped;
  final String currentItemEquipped;

  ItemCard(
      {this.item,
      this.slot,
      this.skillsAlreadyEquipped,
      this.currentItemEquipped});

  @override
  Widget build(BuildContext context) {
    void openItemInfo(Map item) async {
      final Map equippedIdLevel = await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ItemInfo(
            item: item,
            slot: slot,
          ),
          transitionDuration: Duration(seconds: 0),
        ),
      );

      if (equippedIdLevel != null) {
        Navigator.of(context).pop(equippedIdLevel);
      }
    }

    String name = item['name'];
    String iconPath = 'assets/icons/icon-${item['id']}.png';
    int cost = item['levels'][0]['cost'];

    bool itemEquippedSameSlot = currentItemEquipped == item['id'];
    bool alreadyEquipped = skillsAlreadyEquipped.contains(item['id']);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!alreadyEquipped) {
          if (item['id'] == 'nothing') {
            Navigator.pop(context, {'id': 'nothing', 'level': 1});
          } else {
            openItemInfo(item);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Opacity(
                  opacity: alreadyEquipped ? 0.5 : 1,
                  child: Image.asset(
                    iconPath,
                    height: 50,
                  ),
                )),
            (() {
              if (alreadyEquipped || itemEquippedSameSlot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Opacity(
                    opacity: itemEquippedSameSlot ? 1 : 0.5,
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }()),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Opacity(
                opacity: alreadyEquipped ? 0.5 : 1,
                child: Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Opacity(
                opacity: alreadyEquipped ? 0.5 : 1,
                child: Text(
                  '$cost',
                  style: TextStyle(
                    color: (() {
                      if (Provider.of<LoadoutModel>(context, listen: false)
                          .canReplaceItem(slot, cost)) {
                        return Colors.lightBlue[200];
                      } else {
                        return Colors.redAccent;
                      }
                    }()),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
