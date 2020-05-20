import 'package:flutter/material.dart';

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

  void equipItem(String id, int level, int slot) {
    loadout[slot]['id'] = id;
    loadout[slot]['level'] = level;
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
    loadout = newLoadout;
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
}
