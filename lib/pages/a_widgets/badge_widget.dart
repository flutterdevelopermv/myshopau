import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import 'text_widget.dart';

class BadgeIcon extends StatelessWidget {
  final int count;

  final IconData iconData;
  // final Color? color;
  const BadgeIcon({super.key, required this.count, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
        showBadge: count > 0,
        badgeContent: TextW(
          count.toString(),
          color: Colors.yellow.shade50,
          textScaleFactor: count > 9 ? 0.6 : null,
        ),
        badgeAnimation:
            const badges.BadgeAnimation.scale(curve: Curves.bounceOut),
        child: Icon(iconData));
  }
}
