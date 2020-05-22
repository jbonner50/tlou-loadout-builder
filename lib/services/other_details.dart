import 'package:flutter/material.dart';

class OtherDetails extends StatelessWidget {
  final Map item;
  final int slot;

  OtherDetails({this.item, this.slot});

  @override
  Widget build(BuildContext context) {
    Widget statBar(int stat) {
      List<Widget> boxes = [];
      for (int i = 1; i <= 10; i++) {
        boxes.add(Expanded(
          child: Opacity(
            opacity: i <= stat ? 1 : 0.2,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border.all(width: 1)),
              height: 10,
            ),
          ),
        ));
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
        child: Row(
          children: boxes,
        ),
      );
    }

    Widget statBars() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fire Rate',
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
          statBar(item['rate']),
          Text(
            'Reload Speed',
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
          statBar(item['reload']),
          Text(
            'Damage',
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
          statBar(item['damage']),
          Text(
            'Accuracy',
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
          statBar(item['accuracy']),
        ],
      );
    }

    Widget generalStatsWidget(Map generalData) {
      if (slot <= 1) {
        return Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ammo (# / Cost) :  ${generalData['ammo']} / ${generalData['ammo cost']} Parts',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
              Text(
                'Upgrade #1 :   ${generalData['cost lvl 1']} Parts',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
              Text(
                'Upgrade #2 :   ${generalData['cost lvl 2']} Parts',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Purchase Cost :   ${generalData['purchase cost']} Parts',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
              Text(
                'Ammo (# / Initial Cost) :  ${generalData['ammo']} / ${generalData['initial ammo cost']} Parts',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
              Text(
                'Clip Size :   ${generalData['clip size']}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20),
              ),
            ],
          ),
        );
      }
    }

    Widget damageStatsWidget(Map damageData) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Theme.of(context).accentColor,
        ),
        child: DataTable(columns: [
          DataColumn(
            label: Text(''),
          ),
          DataColumn(
            label: Text(
              'Body',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
                fontFamily: 'TLOU',
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Head',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
                fontFamily: 'TLOU',
              ),
            ),
          ),
        ], rows: [
          DataRow(cells: [
            DataCell(
              Text(
                'Damage (%)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                  fontFamily: 'TLOU',
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${damageData['body']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${damageData['head']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'Destroy Armor (shots)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'TLOU',
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${damageData['destroy body']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${damageData['destroy head']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'Damage Dealt by Breaking Armor (%)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'TLOU',
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${damageData['break damage body']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${damageData['break damage head']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ])
        ]),
      );
    }

    Widget upgradeStatsWidget(Map upgradeData) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Theme.of(context).accentColor,
        ),
        child: DataTable(columns: [
          DataColumn(
            label: Text(''),
          ),
          DataColumn(
            label: Text(
              'Spawn Ammo',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
                fontFamily: 'TLOU',
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Clip Size',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
                fontFamily: 'TLOU',
              ),
            ),
          ),
        ], rows: [
          DataRow(cells: [
            DataCell(
              Text(
                'Base',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                  fontFamily: 'TLOU',
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${upgradeData['spawn ammo base']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${upgradeData['clip size base']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'Upgrade #1',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                  fontFamily: 'TLOU',
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${upgradeData['spawn ammo lvl 1']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${upgradeData['clip size lvl 1']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'Upgrade #2',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                  fontFamily: 'TLOU',
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${upgradeData['spawn ammo lvl 2']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  '${upgradeData['clip size lvl 2']}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'TLOU',
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
        ]),
      );
    }

    Widget statsWidgets() {
      if (slot <= 1) {
        Map generalData = item['general stats'];
        Map damageData = item['damage stats'];
        Map upgradeData = item['upgrade stats'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'General Stats',
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: generalStatsWidget(generalData),
            ),
            Text(
              'Damage Stats',
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: damageStatsWidget(damageData),
            ),
            Text(
              'Upgrade Stats',
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: upgradeStatsWidget(upgradeData),
            ),
          ],
        );
      } else if (slot == 6) {
        Map generalData = item['general stats'];
        Map damageData = item['damage stats'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'General Stats',
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: generalStatsWidget(generalData),
            ),
            Text(
              'Damage Stats',
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: damageStatsWidget(damageData),
            ),
          ],
        );
      }
      return Container();
    }

    if (slot <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          statBars(),
          Divider(
            thickness: 2,
            height: 30,
            color: Theme.of(context).accentColor,
          ),
          statsWidgets(),
        ],
      );
    } else if (slot == 6) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          statBars(),
          Divider(
            thickness: 2,
            height: 30,
            color: Theme.of(context).accentColor,
          ),
          statsWidgets(),
        ],
      );
    } else {
      return Column(
        children: [
          Divider(
            thickness: 2,
            height: 30,
            color: Theme.of(context).accentColor,
          ),
          statsWidgets(),
        ],
      );
    }
  }
}
