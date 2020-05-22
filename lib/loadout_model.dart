import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadoutModel extends ChangeNotifier {
  int currentIndex = 0;
  bool wasJustSent = false;
  String loadoutNameJustSent;

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void setWasJustSent(bool b) {
    wasJustSent = b;
    notifyListeners();
  }

  List loadout = [
    {
      'id': 'revolver',
      'level': 1,
    },
    {
      'id': 'nothing',
      'level': 1,
    },
    {
      'id': 'nothing',
      'level': 1,
    },
    {
      'id': 'nothing',
      'level': 1,
    },
    {
      'id': 'nothing',
      'level': 1,
    },
    {
      'id': 'nothing',
      'level': 1,
    },
    {
      'id': 'nothing',
      'level': 1,
    }
  ];

  Map data = {
    "small": [
      {
        "id": "revolver",
        "name": "Revolver",
        "levels": [
          {
            "description": "Deals a solid punch with good accuracy when still.",
            "cost": 0,
            "code": "01"
          }
        ],
      },
    ],
    "large": [
      {
        "id": "nothing",
        "name": "No Large Firearm",
        "levels": [
          {"description": "", "cost": 0, "code": "08"}
        ]
      },
    ],
    "skill": [
      {
        "id": "nothing",
        "name": "Nothing",
        "levels": [
          {"description": "", "cost": 0, "code": "17"}
        ]
      },
    ],
    "purchase": [
      {
        "id": "nothing",
        "name": "No Purchasable",
        "levels": [
          {"description": "", "cost": 0, "code": "75"}
        ]
      },
    ]
  };

  List get small => data['small'];
  List get large => data['large'];
  List get purchase => data['purchase'];
  List get skill => data['skill'];

  int points = 13;

  void equipItem(Map item, int slot) {
    loadout[slot] = item;

    updatePoints();
    notifyListeners();
  }

  void resetLoadout() {
    loadout = [
      {
        'id': 'revolver',
        'level': 1,
      },
      {
        'id': 'nothing',
        'level': 1,
      },
      {
        'id': 'nothing',
        'level': 1,
      },
      {
        'id': 'nothing',
        'level': 1,
      },
      {
        'id': 'nothing',
        'level': 1,
      },
      {
        'id': 'nothing',
        'level': 1,
      },
      {
        'id': 'nothing',
        'level': 1,
      }
    ];
    updatePoints();
    notifyListeners();
  }

  void updatePoints() {
    points = 13;
    for (int slotNum = 0; slotNum < 7; slotNum++) {
      String slotID = loadout[slotNum]['id'];
      int slotLevel = loadout[slotNum]['level'];
      points -= findFullItem(slotID, slotNum)['levels'][slotLevel - 1]['cost'];
    }
  }

  void sendToBuilder(String name, List newLoadout) {
    loadout = List.from(newLoadout);
    wasJustSent = true;
    loadoutNameJustSent = name;
    currentIndex = 0;
    updatePoints();
    notifyListeners();
  }

  List getList(int slot) {
    switch (slot) {
      case 0:
        return small;
        break;
      case 1:
        return large;
        break;
      case 6:
        return purchase;
        break;
      default:
        return skill;
    }
  }

  Map findFullItem(String id, int slot) {
    List typeList = getList(slot);
    for (var item in typeList) {
      if (item['id'] == id) {
        return item;
      }
    }
    return null;
  }

  bool canReplaceItem(int slot, int newItemCost) {
    String slotID = loadout[slot]['id'];
    int slotLevel = loadout[slot]['level'];
    int equippedItemCost =
        findFullItem(slotID, slot)['levels'][slotLevel - 1]['cost'];
    return (newItemCost <= equippedItemCost ||
        points - (newItemCost - equippedItemCost) >= 0);
  }

  List skillsEquippedDifferentSlots(int currentSlot) {
    List skillsEquipped = [];
    for (int slotNum = 0; slotNum < 7; slotNum++) {
      if (slotNum != currentSlot &&
          slotNum >= 2 &&
          slotNum <= 5 &&
          loadout[slotNum]['id'] != 'nothing') {
        skillsEquipped.add(loadout[slotNum]['id']);
      }
    }
    return skillsEquipped;
  }

  String itemEquippedSameSlot(int currentSlot) {
    String id = '';
    for (int slotNum = 0; slotNum < 7; slotNum++) {
      if (slotNum == currentSlot && loadout[slotNum]['id'] != 'nothing') {
        id = loadout[slotNum]['id'];
      }
    }
    return id;
  }

  String copyLoadoutLink(List loadoutToShare) {
    String url = 'http://tlou-loadout.com/?q=';
    loadoutToShare.forEach((item) {
      String code =
          findFullItem(item['id'], loadoutToShare.indexOf(item))['levels']
              [item['level'] - 1]['code'];
      url += code;
    });
    ClipboardData data = ClipboardData(text: url);
    Clipboard.setData(data);
  }

  List importLoadout(String url) {
    List importedLoadout = [];
    Uri uri = Uri.dataFromString(url);
    String codes = uri.queryParameters['q'];
    print(codes);
    if (codes == null) {
      return null;
    } else if (codes.length < 14) {
      return null;
    }
    String smallCode = codes.substring(0, 2);
    String largeCode = codes.substring(2, 4);
    String skill1Code = codes.substring(4, 6);
    String skill2Code = codes.substring(6, 8);
    String skill3Code = codes.substring(8, 10);
    String skill4Code = codes.substring(10, 12);
    String purchaseCode = codes.substring(12, 14);

    OUTER:
    for (var item in small) {
      for (var level in item['levels']) {
        if (level['code'] == smallCode) {
          importedLoadout.add(
              {'id': item['id'], 'level': item['levels'].indexOf(level) + 1});
          break OUTER;
        }
      }
    }
    if (importedLoadout.length < 1) {
      return null;
    }
    OUTER:
    for (var item in large) {
      for (var level in item['levels']) {
        if (level['code'] == largeCode) {
          importedLoadout.add(
              {'id': item['id'], 'level': item['levels'].indexOf(level) + 1});
          break OUTER;
        }
      }
    }
    if (importedLoadout.length < 2) {
      return null;
    }

    Map skill1, skill2, skill3, skill4;
    for (var item in skill) {
      for (var level in item['levels']) {
        if (level['code'] == skill1Code) {
          skill1 = {
            'id': item['id'],
            'level': item['levels'].indexOf(level) + 1
          };
        }
        if (level['code'] == skill2Code) {
          skill2 = {
            'id': item['id'],
            'level': item['levels'].indexOf(level) + 1
          };
        }
        if (level['code'] == skill3Code) {
          skill3 = {
            'id': item['id'],
            'level': item['levels'].indexOf(level) + 1
          };
        }
        if (level['code'] == skill4Code) {
          skill4 = {
            'id': item['id'],
            'level': item['levels'].indexOf(level) + 1
          };
        }
      }
    }
    print(skill1Code);
    print(skill2Code);
    print(skill3Code);
    print(skill4Code);
    if (skill1 == null || skill2 == null || skill3 == null || skill4 == null) {
      return null;
    }
    print('got here');
    importedLoadout.add(skill1);
    importedLoadout.add(skill2);
    importedLoadout.add(skill3);
    importedLoadout.add(skill4);

    OUTER:
    for (var item in purchase) {
      for (var level in item['levels']) {
        if (level['code'] == purchaseCode) {
          importedLoadout.add(
              {'id': item['id'], 'level': item['levels'].indexOf(level) + 1});
          break OUTER;
        }
      }
    }
    if (importedLoadout.length < 7) {
      return null;
    }

    return importedLoadout;
  }
}
