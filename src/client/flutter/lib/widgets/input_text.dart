import 'package:flutter/material.dart';
import '../models/enums/position_input.dart';

class InputText extends StatefulWidget {
  final String placeholder;
  final PositionInput position;
  final String? value;
  final bool obscureText;
  final bool isReadOnly;
  final double? height;
  final double? width;
  final TextEditingController? controller;

  InputText({Key? key,
    required this.placeholder,
    this.obscureText = false,
    this.isReadOnly = false,
    this.value,
    this.controller,
    this.width,
    this.height,
    this.position = PositionInput.middle})
      : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final double radius = 10;

  FloatingLabelBehavior labelBehavior = FloatingLabelBehavior.auto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: FocusScope(
        onFocusChange: focusChanged,
        child: TextField(
          controller: widget.controller,
          readOnly: widget.isReadOnly,
          obscureText: widget.obscureText,
          style: Theme
              .of(context)
              .textTheme
              .bodyText1,
          decoration: InputDecoration(
            fillColor: (widget.isReadOnly)
                ? Theme
                .of(context)
                .disabledColor
                : Colors.white,
            floatingLabelBehavior: labelBehavior,
            labelText: widget.placeholder,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme
                  .of(context)
                  .primaryColor),
              borderRadius: getBorderRadius(),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: getBorderRadius(),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius getBorderRadius() {
    switch (widget.position) {
      case PositionInput.middle:
        return BorderRadius.all(Radius.circular(0));

      case PositionInput.start:
        return BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius));

      case PositionInput.end:
        return BorderRadius.only(
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius));
    }
  }

  void focusChanged(isFocus) {
    setState(() {
      if (widget.isReadOnly) {
        FocusScope.of(context).unfocus();
      } else {
        labelBehavior = (isFocus)
            ? FloatingLabelBehavior.never
            : FloatingLabelBehavior.auto;
      }
    });
  }
}
