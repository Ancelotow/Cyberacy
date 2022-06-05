// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ButtonCard extends StatefulWidget {
  Color? color;
  String label;
  IconData icon;
  Function()? onTap;

  Color? colorText;
  Color? colorCard;

  ButtonCard({
    Key? key,
    this.color,
    this.onTap,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {


  @override
  Widget build(BuildContext context) {
    widget.color ??= Theme.of(context).primaryColor;
    widget.colorCard ??= Colors.transparent;
    widget.colorText ??= widget.color;
    return GestureDetector(
      onTap: widget.onTap,
      child: Listener(
        onPointerDown: buttonPressedDown,
        onPointerUp: buttonPressedUp,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 500,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: widget.colorCard,
              border: Border(
                top: BorderSide(width: 1.0, color: widget.color!),
                left: BorderSide(width: 1.0, color: widget.color!),
                right: BorderSide(width: 1.0, color: widget.color!),
                bottom: BorderSide(width: 1.0, color: widget.color!),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: widget.colorText,
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.colorText,
                    fontFamily: "HK-Nova",
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buttonPressedDown(PointerDownEvent event) {
    setState(() {
      widget.colorCard = widget.color;
      widget.colorText = Colors.black;
    });
  }

  void buttonPressedUp(PointerUpEvent event) {
    setState(() {
      widget.colorCard = Colors.transparent;
      widget.colorText = widget.color;
    });
  }

}
