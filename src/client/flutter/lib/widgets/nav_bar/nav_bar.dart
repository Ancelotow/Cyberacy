import 'package:bo_cyberacy/models/enums/orientation_nav_bar.dart';
import 'package:bo_cyberacy/widgets/nav_bar/nav_bar_item.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  Color? color;
  OrientationNavBar orientation;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<NavBarItem> items;
  final Color colorSelected;
  final Color colorUnselected;

  NavBar(
      {Key? key,
      required this.items,
      this.color,
      this.orientation = OrientationNavBar.horizontal,
      this.colorSelected = Colors.white,
      this.colorUnselected = Colors.black,
      this.mainAxisAlignment = MainAxisAlignment.spaceAround,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  NavBarItem? itemSelected;

  @override
  Widget build(BuildContext context) {
    widget.color ??= Theme.of(context).primaryColor;
    return Container(
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: getBody(
          context: context,
          children: getItems(),
        ),
      ),
    );
  }

  List<Widget> getItems() {
    List<Widget> listItems = [];
    Color color;
    for (NavBarItem item in widget.items) {
      color = (item == itemSelected)
          ? widget.colorSelected
          : widget.colorUnselected;
      listItems.add(buildItem(item, color));
    }
    return listItems;
  }

  Widget buildItem(NavBarItem item, Color color) {
    return GestureDetector(
      onTap: () {
        if (itemSelected != item) {
          setState(() {
            itemSelected = item;
          });
          item.onTap?.call();
        }
      },
      child: Column(
        children: [
          Icon(
            item.icon,
            color: color,
          ),
          Text(
            item.label,
            style: TextStyle(color: color),
          )
        ],
      ),
    );
  }

  Flex getBody(
      {required BuildContext context, required List<Widget> children}) {
    if (widget.orientation == OrientationNavBar.horizontal) {
      return Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: children,
      );
    } else {
      return Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: children,
      );
    }
  }
}
