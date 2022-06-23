import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/enums/orientation_nav_bar.dart';
import 'package:bo_cyberacy/pages/manifestion_page.dart';
import 'package:bo_cyberacy/pages/party_page.dart';
import 'package:bo_cyberacy/pages/vote_page.dart';
import 'package:bo_cyberacy/pages/workspace_page.dart';
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
  List<PoliticalParty> parties = [];
  Widget currentPage = PartyPage();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          currentPage,
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: NavBar(
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
                  icon: Icons.laptop_chromebook_outlined,
                  label: "Espace travaille",
                  onTap: click,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void click(int index) {
    Widget newPage;
    switch(index) {
      case 0:
        newPage = PartyPage(callbackAddWorkspace: (value) {
          addPartyInWorkspace(value, context);
        });
        break;

      case 1:
        newPage = ManifestationPage();
        break;

      case 2:
        newPage = VotePage();
        break;

     default:
        newPage = WorkspacePage(parties: parties);
        break;
    }
    setState(() {
      currentIndex = index;
      currentPage = newPage;
    });
  }

  void addPartyInWorkspace(PoliticalParty value, BuildContext context) {
    bool isExists = parties.where((p) => p.id == value.id).isNotEmpty;
    if(!isExists) {
      parties.add(value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ce parti politique est déjà dans l'espace de travail"),
      ));
    }
  }

}
