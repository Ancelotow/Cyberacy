import 'package:bo_cyberacy/models/enums/orientation_nav_bar.dart';
import 'package:bo_cyberacy/pages/manifestion_page.dart';
import 'package:bo_cyberacy/pages/party_page.dart';
import 'package:bo_cyberacy/pages/vote_page.dart';
import 'package:bo_cyberacy/widgets/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar/nav_bar_item.dart';

class NavigationPage extends StatefulWidget {
  static const String routeName = "navigationPage";

  NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  Widget currentPage = PartyPage();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          currentPage,
          NavBar(
            orientation: OrientationNavBar.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            color: Theme.of(context).buttonColor,
            colorUnselected: Colors.white,
            colorSelected: Theme.of(context).accentColor,
            indexSelected: currentIndex,
            items: [
              NavBarItem(
                icon: Icons.group,
                label: "Partis politiques",
                onTap: click,
              ),
              NavBarItem(
                icon: Icons.flag,
                label: "Manifestations",
                onTap: click,
              ),
              NavBarItem(
                icon: Icons.how_to_vote,
                label: "Votes",
                onTap: click,
              ),
              NavBarItem(
                icon: Icons.person,
                label: "Utilisateurs",
                onTap: click,
              ),
              NavBarItem(
                icon: Icons.account_circle,
                label: "Mon compte",
                onTap: click,
              )
            ],
          ),
        ],
      ),
    );
  }

  void click(int index) {
    Widget newPage;
    switch(index) {
      case 0:
        newPage = PartyPage();
        break;

      case 1:
        newPage = ManifestationPage();
        break;

      case 2:
        newPage = VotePage();
        break;

     default:
        newPage = PartyPage();
        break;
    }
    setState(() {
      currentIndex = index;
      currentPage = newPage;
    });
  }


}
