import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/services/other_details.dart';

class ItemInfo extends StatefulWidget {
  final Map item;
  final int slot;

  ItemInfo({this.item, this.slot});
  @override
  _ItemInfoState createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  int selectedLevel = 1;

  void selectItem() {
    final Map equippedIdLevel = {
      'id': widget.item['id'],
      'level': selectedLevel,
    };
    Navigator.of(context).pop(equippedIdLevel);
  }

  @override
  Widget build(BuildContext context) {
    bool canReplace = Provider.of<LoadoutModel>(context, listen: false)
        .canReplaceItem(
            widget.slot, widget.item['levels'][selectedLevel - 1]['cost']);

    List<Widget> createLevelWidgets() {
      List<Widget> levelWidgets = [];
      List levels = widget.item['levels'];
      for (Map levelInfo in levels) {
        int level = levels.indexOf(levelInfo) + 1;
        levelWidgets.add(
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() {
              selectedLevel = level;
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: (() {
                      if (level == selectedLevel) {
                        return BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).accentColor,
                            width: 2,
                          ),
                        );
                      } else {
                        return null;
                      }
                    }()),
                  ),
                  Image.asset(
                      (() {
                        if (level == 1) {
                          return 'assets/icons/icon-${widget.item['id']}.png';
                        } else if (widget.slot <= 1) {
                          return 'assets/icons/icon-silencer.png';
                        } else {
                          return 'assets/icons/icon-${widget.item['id']}-$level.png';
                        }
                      }()),
                      height: 60,
                      width: 120),
                ],
              ),
            ),
          ),
        );
      }
      return levelWidgets;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
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
              widget.item['name'],
              style:
                  TextStyle(fontSize: 25, color: Theme.of(context).accentColor),
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
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Text(
              'SELECT LEVEL',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25,
              ),
            ),
            Row(
              children: createLevelWidgets(),
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Divider(
              thickness: 2,
              color: Theme.of(context).accentColor,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    (() {
                      if (widget.slot <= 1 ||
                          widget.slot == 6 ||
                          selectedLevel == 1) {
                        return 'assets/icons/icon-${widget.item['id']}.png';
                      } else {
                        return 'assets/icons/icon-${widget.item['id']}-$selectedLevel.png';
                      }
                    }()),
                    width: 70,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        (() {
                          if (widget.slot <= 1) {
                            if (selectedLevel == 1) {
                              return '${widget.item['name']}';
                            } else {
                              return 'Silenced ${widget.item['name']}';
                            }
                          } else {
                            return '${widget.item['name']} $selectedLevel';
                          }
                        }()),
                        maxLines: 1,
                        // minFontSize: 25,
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Text(
                        '${widget.item['levels'][selectedLevel - 1]['cost']} ${widget.item['levels'][selectedLevel - 1]['cost'] == 1 ? 'Point' : 'Points'}',
                        style: TextStyle(
                          fontSize: 25,
                          color: (() {
                            if (canReplace) {
                              return Colors.lightBlue[200];
                            } else {
                              return Colors.redAccent[700];
                            }
                          }()),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Opacity(
                      opacity: canReplace ? 1 : 0.5,
                      child: ActionChip(
                          backgroundColor: (() {
                            if (canReplace) {
                              return Colors.lightBlueAccent;
                            } else {
                              return Colors.grey;
                            }
                          }()),
                          avatar: Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'EQUIP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            if (canReplace) {
                              selectItem();
                            }
                          }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${widget.item['levels'][selectedLevel - 1]['description']}',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(height: 10),
            OtherDetails(
              slot: widget.slot,
              item: widget.item,
            ),
          ],
        ),
      ),
    );
  }
}
