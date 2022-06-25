import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/enums/orientation_nav_bar.dart';
import 'package:bo_cyberacy/pages/manifestion_page.dart';
import 'package:bo_cyberacy/pages/party_page.dart';
import 'package:bo_cyberacy/pages/screen_404.dart';
import 'package:bo_cyberacy/pages/vote_page.dart';
import 'package:bo_cyberacy/widgets/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';

import '../models/entities/manifestation.dart';
import '../models/notifications/navigation_notification.dart';
import '../widgets/nav_bar/nav_bar_item.dart';

class NavigationPage extends StatefulWidget {
  static const String routeName = "navigationPage";

  NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List<PoliticalParty> parties = [];
  List<Manifestation> manifs = [];
  late Widget currentPage;
  int currentIndex = 2;

  @override
  void initState() {
    click(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: NavBar(
              color: Theme.of(context).bottomAppBarColor,
              colorUnselected: Theme.of(context).unselectedWidgetColor,
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
                  label: "Vote",
                  onTap: click,
                ),
                NavBarItem(
                  icon: Icons.person,
                  label: "Utilisateurs",
                  onTap: click,
                ),
              ],
            ),
          ),
          Expanded(
            child: currentPage,
          ),
        ],
      ),
    );
  }

  void click(int index) {
    Widget newPage;
    switch (index) {
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
        newPage = const Screen404();
        break;
    }
    currentIndex = index;
    changePage(newPage);
  }

  void changePage(Widget page) {
    setState(() {
      currentPage = NotificationListener<NavigationNotification>(
        onNotification: (notification) {
          setState(() => { changePage(notification.page) });
          return true;
        },
        child: page,
      );
    });
  }

}
