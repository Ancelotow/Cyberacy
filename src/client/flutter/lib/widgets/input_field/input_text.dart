import 'package:flutter/material.dart';
import '../../models/enums/position_input.dart';

class InputText extends StatefulWidget {
  final String placeholder;
  final PositionInput position;
  final String? value;
  final bool obscureText;
  final bool isReadOnly;
  final TextInputType type;
  final double? height;
  final double? width;
  final TextEditingController? controller;

  const InputText({Key? key,
    required this.placeholder,
    this.obscureText = false,
    this.isReadOnly = false,
    this.value,
    this.controller,
    this.width,
    this.height,
    this.type = TextInputType.text,
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
      child: TextField(
        keyboardType: widget.type,
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
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme
                .of(context)
                .primaryColor),
            borderRadius: getBorderRadius(),
          ),
          enabledBorder: UnderlineInputBorder(
              borderRadius: getBorderRadius(),
              borderSide: BorderSide(width: 0.5, color: Colors.grey)
          ),
        ),
      ),
    );
  }

  BorderRadius getBorderRadius() {
    switch (widget.position) {
      case PositionInput.middle:
        return const BorderRadius.all(Radius.circular(0));

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


}
