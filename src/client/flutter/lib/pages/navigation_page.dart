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
            crossAxisAlignment: CrossAxisAlignment.center,
            color: Theme.of(context).primaryColorDark,
            items: [
              NavBarItem(
                icon: Icons.group,
                label: "Partis politiques",
              ),
              NavBarItem(
                icon: Icons.flag,
                label: "Manifestations",
              ),
              NavBarItem(
                icon: Icons.how_to_vote,
                label: "Votes",
              ),
              NavBarItem(
                icon: Icons.person,
                label: "Utilisateurs",
              ),
              NavBarItem(
                icon: Icons.account_circle,
                label: "Mon compte",
              )
            ],
          )
        ],
      ),
    );
  }
}
