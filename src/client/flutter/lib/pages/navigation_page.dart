import 'package:bo_cyberacy/models/enums/orientation_nav_bar.dart';
import 'package:bo_cyberacy/widgets/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar/nav_bar_item.dart';

class NavigationPage extends StatelessWidget {
  static const String routeName = "navigationPage";

  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          NavBar(
            orientation: OrientationNavBar.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            color: Theme.of(context).primaryColorDark,
            items: [
              NavBarItem(
                icon: Icons.ac_unit_rounded,
                label: "Snow",
                onTap: () {
                  print("object");
                },
              ),
              NavBarItem(
                icon: Icons.access_alarm,
                label: "Alarm",
              )
            ],
          )
        ],
      ),
    );
  }
}
