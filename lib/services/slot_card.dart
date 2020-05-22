import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/my_loadouts_model.dart';
import 'package:tlou_loadout/pages/item_select.dart';

class SlotCard extends StatelessWidget {
  final int slot;
  SlotCard({this.slot});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadoutModel>(
      builder: (context, loadoutModel, child) {
        bool isSilenced = false;

        //refactor
        void selectNewItem(int slot) async {
          final Map equippedIdLevel = await Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ItemSelect(
                slot: slot,
              ),
              transitionDuration: Duration(seconds: 0),
            ),
          );
          if (equippedIdLevel != null) {
            print(Provider.of<MyLoadoutsModel>(context, listen: false)
                .jsonFileContent);
            loadoutModel.equipItem(
              equippedIdLevel,
              slot,
            );
            print(Provider.of<MyLoadoutsModel>(context, listen: false)
                .jsonFileContent);
          }
        }

        final int level = loadoutModel.loadout[slot]['level'];
        final Map item =
            loadoutModel.findFullItem(loadoutModel.loadout[slot]['id'], slot);

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              selectNewItem(slot);
            },
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          (() {
                            if (level != 1) {
                              if (slot >= 2 && slot <= 5) {
                                return 'assets/icons/icon-${item['id']}-$level.png';
                              } else if (slot <= 1) {
                                isSilenced = true;
                                return 'assets/icons/icon-${item['id']}.png';
                              }
                            } else if (slot == 6) {
                              return 'assets/icons/icon-gear.png';
                            } else {
                              isSilenced = false;
                              return 'assets/icons/icon-${item['id']}.png';
                            }
                          }()),
                        ),
                        isSilenced || (slot == 6 && item['id'] != 'nothing')
                            ? Positioned.fill(
                                child: Align(
                                  alignment: isSilenced
                                      ? Alignment.bottomRight
                                      : Alignment.center,
                                  child: Image.asset(
                                    isSilenced
                                        ? 'assets/icons/icon-silencer.png'
                                        : 'assets/icons/icon-${item['id']}.png',
                                    //         color: Color.fromARGB(255, 235, 234, 219),
                                    scale: isSilenced ? 3 : 1,
                                  ),
                                ),
                              )
                            : Container(
                                constraints:
                                    BoxConstraints(maxHeight: 0, maxWidth: 0),
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AutoSizeText(
                      (() {
                        if (slot <= 1 && isSilenced) {
                          return 'Silenced ${item['name']}';
                        } else if (slot >= 2 &&
                            slot <= 5 &&
                            item['id'] != 'nothing') {
                          return '${item['name']} $level';
                        } else {
                          return item['name'];
                        }
                      }()),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      '${item['levels'][level - 1]['cost']}',
                      style: TextStyle(
                        color: Colors.lightBlue[200],
                        fontSize: 25,
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
      },
    );
  }
}
