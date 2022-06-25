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
  final IconData? icon;

  const InputText({
    Key? key,
    required this.placeholder,
    this.obscureText = false,
    this.isReadOnly = false,
    this.value,
    this.controller,
    this.width,
    this.height,
    this.type = TextInputType.text,
    this.position = PositionInput.middle,
    this.icon,
  }) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final double radius = 10;

  FloatingLabelBehavior labelBehavior = FloatingLabelBehavior.auto;
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => isFocus = hasFocus),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextField(
            keyboardType: widget.type,
            controller: widget.controller,
            readOnly: widget.isReadOnly,
            obscureText: widget.obscureText,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              fillColor: (widget.isReadOnly) ? Theme.of(context).disabledColor : null,
              prefixIcon: Icon(
                widget.icon,
                color: _getColor(context),
              ),
              labelText: widget.placeholder,
              labelStyle: TextStyle(
                color: _getColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if(isFocus && !widget.isReadOnly) {
      return Theme.of(context).cursorColor;
    }
    return Theme.of(context).hintColor;
  }

}
