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
      this.mainAxisAlignment = MainAxisAlignment.spaceAround,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).primaryColor;
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: Offset(0, -2), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: getBody(
          context: context,
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
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (itemSelected != item) {
            item.onTap?.call(items.indexOf(item));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: color,
            ),
            Text(
              item.label,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 11,
              ),
            )
          ],
        ),
      ),
    );
  }

  Flex getBody(
      {required BuildContext context, required List<Widget> children}) {
    if (orientation == OrientationNavBar.horizontal) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    }
  }
}
