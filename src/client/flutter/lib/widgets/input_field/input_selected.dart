import 'package:flutter/material.dart';
import '../../models/enums/position_input.dart';

class InputSelected<T> extends StatefulWidget {
  final String placeholder;
  final PositionInput position;
  final T? value;
  final bool isReadOnly;
  final double? height;
  final double? width;
  List<T> items;
  Function(dynamic)? onChanged;
  final IconData? icon;

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
    this.icon,
  }) : super(key: key);

  @override
  State<InputSelected> createState() => _InputSelectedState<T>();
}

class _InputSelectedState<T> extends State<InputSelected> {
  final double radius = 10;
  bool isFocus = false;

  //[DropdownMenuItem<String>(child: Text("test"))]

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => isFocus = hasFocus),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: DropdownButtonFormField<T>(
            items: getItems(),
            value: getValue(),
            onChanged: widget.onChanged,
            isExpanded: true,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
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
    if (isFocus) {
      return Theme.of(context).cursorColor;
    }
    return Theme.of(context).hintColor;
  }

  List<DropdownMenuItem<T>> getItems() {
    List<DropdownMenuItem<T>> list = [];
    for (T value in widget.items) {
      list.add(DropdownMenuItem<T>(
        value: value,
        child: Text(
          value.toString(),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ));
    }
    return list;
  }

  T? getValue() {
    List<DropdownMenuItem<T>> list = [];
    for (T value in widget.items) {
      if (value == widget.value) {
        return value;
      }
    }
    return null;
  }
}
