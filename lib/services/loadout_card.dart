import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/my_loadouts_model.dart';

class LoadoutCard extends StatefulWidget {
  final String name;
  final List loadout;

  LoadoutCard({this.name, this.loadout});

  @override
  _LoadoutCardState createState() => _LoadoutCardState();
}

class _LoadoutCardState extends State<LoadoutCard> {
  final titleController = TextEditingController();

  void saveLoadout(String name, List loadout) {
    Provider.of<MyLoadoutsModel>(context, listen: false)
        .addLoadout(name, loadout);
    Provider.of<LoadoutModel>(context, listen: false).setCurrentIndex(1);
    Provider.of<LoadoutModel>(context, listen: false).resetLoadout();

    Provider.of<LoadoutModel>(context, listen: false).setWasJustSent(false);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    super.dispose();
  }

  Future<void> showSaveLoadoutAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Enter loadout title:'),
          contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          content: TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'ENTER COPY NAME',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (String s) {
              if (s.isNotEmpty) {
                Navigator.of(context).pop();
                Provider.of<LoadoutModel>(context, listen: false).loadout =
                    widget.loadout;
                saveLoadout(titleController.text,
                    Provider.of<LoadoutModel>(context, listen: false).loadout);

                titleController.clear();
              }
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  Provider.of<LoadoutModel>(context, listen: false).loadout =
                      widget.loadout;

                  saveLoadout(
                      titleController.text,
                      Provider.of<LoadoutModel>(context, listen: false)
                          .loadout);

                  titleController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> getLoadoutImages() {
    List<Widget> images = [];
    for (var item in widget.loadout) {
      int slot = widget.loadout.indexOf(item);
      images.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Stack(
              children: [
                (() {
                  if (slot == 6) {
                    return Image.asset('assets/icons/icon-gear.png');
                  } else if (item['level'] > 1 && slot >= 2 && slot <= 5) {
                    return Image.asset(
                        'assets/icons/icon-${item['id']}-${item['level']}.png');
                  } else {
                    return Image.asset('assets/icons/icon-${item['id']}.png');
                  }
                }()),
                (() {
                  if (slot <= 1 && item['level'] > 1) {
                    return Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(
                          'assets/icons/icon-silencer.png',
                          scale: 7,
                        ),
                      ),
                    );
                  } else if (slot == 6 && item['id'] != 'nothing') {
                    return Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/icons/icon-${item['id']}.png',
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }()),
              ],
            ),
          ),
        ),
      ));
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Provider.of<LoadoutModel>(context, listen: false)
            .sendToBuilder(widget.name, widget.loadout);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      widget.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 25,
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.content_copy,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    showSaveLoadoutAlert();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    Provider.of<MyLoadoutsModel>(context, listen: false)
                        .removeLoadout(widget.name);
                  },
                ),
              ],
            ),
            Row(
              children: getLoadoutImages(),
            ),
          ]),
        ),
      ),
    );
  }
}
