import 'package:bo_cyberacy/models/enums/orientation_nav_bar.dart';
import 'package:bo_cyberacy/widgets/nav_bar/nav_bar_item.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  NavBarItem? itemSelected;
  Color? color;
  final OrientationNavBar orientation;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<NavBarItem> items;
  final Color colorSelected;
  final Color colorUnselected;
  final int indexSelected;

  NavBar(
      {Key? key,
      required this.items,
      this.color,
      this.orientation = OrientationNavBar.horizontal,
      this.colorSelected = Colors.white,
      this.colorUnselected = Colors.black,
      this.indexSelected = 0,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: Offset(2, 0), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getItems(context),
        ),
      ),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> listItems = [];
    Color color;
    itemSelected = items[indexSelected];
    for (NavBarItem item in items) {
      color = (item == itemSelected) ? colorSelected : colorUnselected;
      listItems.add(buildItem(item, color));
    }
    return listItems;
  }

  Widget buildItem(NavBarItem item, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => item.onTap?.call(items.indexOf(item)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
