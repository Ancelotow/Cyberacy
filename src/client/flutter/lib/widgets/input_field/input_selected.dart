import 'package:flutter/material.dart';
import '../../models/enums/position_input.dart';

class InputSelected<T> extends StatefulWidget {
  final String placeholder;
  final PositionInput position;
  final String? value;
  final bool isReadOnly;
  final double? height;
  final double? width;
  List<T> items;
  Function(dynamic)? onChanged;

  InputSelected({
    Key? key,
    required this.placeholder,
    this.isReadOnly = false,
    this.value,
    this.width,
    this.height,
    this.onChanged,
    this.position = PositionInput.middle,
    required this.items,
  }) : super(key: key);

  @override
  State<InputSelected> createState() => _InputSelectedState<T>();
}

class _InputSelectedState<T> extends State<InputSelected> {
  final double radius = 10;

  //[DropdownMenuItem<String>(child: Text("test"))]

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: DropdownButtonFormField<T>(
        items: getItems(),
        onChanged: widget.onChanged,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          fillColor: (widget.isReadOnly)
              ? Theme.of(context).disabledColor
              : Colors.white,
          labelText: widget.placeholder,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: getBorderRadius(),
          ),
          enabledBorder: UnderlineInputBorder(
              borderRadius: getBorderRadius(),
              borderSide: BorderSide(width: 0.5, color: Colors.grey)),
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

  List<DropdownMenuItem<T>> getItems() {
    List<DropdownMenuItem<T>> list = [];
    for (T value in widget.items) {
      list.add(DropdownMenuItem<T>(
        value: value,
        child: Text(value.toString()),
      ));
    }
    return list;
  }
}
