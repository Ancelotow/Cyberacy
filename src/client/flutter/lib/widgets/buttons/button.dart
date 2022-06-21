import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String label;
  final bool isEnable;
  final double width;
  Color? color;
  Color? pressedColor;
  TextStyle? textStyle;
  Function()? click;

  double? currentWidth;
  Color? currentColor;

  Button({
    Key? key,
    required this.label,
    required this.width,
    this.isEnable = true,
    this.color,
    this.pressedColor,
    this.textStyle,
    this.click,
  }) : super(key: key) {
    currentWidth = width;
  }

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  double height = 45;

  @override
  Widget build(BuildContext context) {
    initValues();
    return Container(
      width: widget.width,
      height: 45,
      alignment: Alignment.center,
      child: Listener(
        onPointerDown: buttonPressedDown,
        onPointerUp: buttonPressedUp,
        child: GestureDetector(
          onTap: () {
            if (widget.isEnable) {
              widget.click?.call();
            }
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: (widget.isEnable)
                  ? widget.currentColor
                  : Theme.of(context).disabledColor,
            ),
            width: widget.currentWidth,
            height: height,
            duration: const Duration(milliseconds: 100),
            child: Center(
              child: Text(
                widget.label,
                style: widget.textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initValues() {
    widget.color ??= Theme.of(context).buttonColor;
    widget.pressedColor ??= widget.color;
    widget.currentColor ??= widget.color;
    widget.pressedColor ??= Theme.of(context).hoverColor;
    widget.textStyle ??= Theme.of(context).textTheme.button;
  }

  void buttonPressedDown(PointerDownEvent event) {
    if (widget.isEnable) {
      setState(() {
        widget.currentWidth = widget.width - (widget.width * 0.10);
        widget.currentColor = widget.pressedColor;
        height = 40;
      });
    }
  }

  void buttonPressedUp(PointerUpEvent event) {
    if (widget.isEnable) {
      setState(() {
        widget.currentWidth = widget.width;
        widget.currentColor = widget.color;
        height = 45;
      });
    }
  }
}
