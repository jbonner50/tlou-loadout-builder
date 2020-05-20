import 'package:flutter/material.dart';

class WeaponStats extends StatelessWidget {
  final int rate;
  final int reload;
  final int damage;
  final int accuracy;

  WeaponStats({this.rate, this.reload, this.damage, this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Text('weapon stats');
  }
}
