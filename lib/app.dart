import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlou_loadout/loadout_model.dart';
import 'package:tlou_loadout/my_loadouts_model.dart';
import 'package:tlou_loadout/pages/item_select.dart';
import 'package:tlou_loadout/pages/loadout_builder.dart';
import 'package:tlou_loadout/pages/my_loadouts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AssetImage bg;
  final titleController = TextEditingController();

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deeplink = data?.link;

    if (deeplink.path == '?q=01082617171775') {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ItemSelect(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    bg = AssetImage('assets/bg.jpg');
    getApplicationDocumentsDirectory().then((Directory directory) {
      Provider.of<MyLoadoutsModel>(context, listen: false).jsonFile =
          new File(directory.path + '/saved_loadouts.json');
      Provider.of<MyLoadoutsModel>(context, listen: false)
          .updateJsonFileContent();
      //delete json file
      // Provider.of<MyLoadoutsModel>(context, listen: false)
      //     .jsonFile
      //     .deleteSync();
      //store file contents in map
      // fileContent = json.decode(jsonFile.readAsStringSync());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(bg, context);
  }

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
            textCapitalization: TextCapitalization.characters,
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'ENTER LOADOUT NAME',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (String s) {
              if (s.isNotEmpty) {
                Navigator.of(context).pop();

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

  Map<String, List> tabInfo = {
    'tab': [
      LoadoutBuilder(),
      MyLoadouts(),
    ],
    'title': ['BUILDER', 'MY LOADOUTS']
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () => Navigator.pop(c, true),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Consumer<LoadoutModel>(
        builder: (context, loadoutModel, child) {
          int currentIndex = loadoutModel.currentIndex;
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: bg,
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
                  child: AutoSizeText(
                    loadoutModel.wasJustSent && currentIndex != 1
                        ? Provider.of<LoadoutModel>(context, listen: false)
                            .loadoutNameJustSent
                            .toUpperCase()
                        : tabInfo['title'][currentIndex],
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                actions: (() {
                  if (currentIndex == 0) {
                    return <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          Provider.of<LoadoutModel>(context, listen: false)
                              .resetLoadout();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          loadoutModel.wasJustSent
                              ? Icons.done
                              : Icons.bookmark_border,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          if (loadoutModel.wasJustSent) {
                            saveLoadout(
                                Provider.of<LoadoutModel>(context,
                                        listen: false)
                                    .loadoutNameJustSent,
                                Provider.of<LoadoutModel>(context,
                                        listen: false)
                                    .loadout);
                          } else {
                            showSaveLoadoutAlert();
                          }
                        },
                      ),
                      loadoutModel.wasJustSent
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                loadoutModel.resetLoadout();
                                loadoutModel.setWasJustSent(false);
                                loadoutModel.setCurrentIndex(1);
                              },
                            )
                          : Container(),
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
                    ];
                  } else {
                    return null;
                  }
                }()),
              ),
              body: tabInfo['tab'][currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.black45,
                  unselectedItemColor: Colors.grey[600],
                  selectedItemColor: Theme.of(context).accentColor,
                  currentIndex: currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.build),
                      title: Text('BUILDER'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      title: Text('MY LOADOUTS'),
                    ),
                  ],
                  onTap: (index) =>
                      Provider.of<LoadoutModel>(context, listen: false)
                          .setCurrentIndex(index)),
            ),
          );
        },
      ),
    );
  }
}
