import 'package:flutter/material.dart';
import '../../models/enums/position_input.dart';
import 'input_text.dart';

class InputSelected<T> extends StatefulWidget {
  final String placeholder;
  final T? value;
  final bool isReadOnly;
  final double? height;
  final double? width;
  List<T> items = [];
  Function(dynamic)? onChanged;
  final IconData? icon;
  final Future<List<T>>? future;
  final String? Function(dynamic)? validator;


  InputSelected({
    Key? key,
    required this.placeholder,
    this.isReadOnly = false,
    this.value,
    this.width,
    this.height,
    this.onChanged,
    required this.items,
    this.icon,
    this.future,
    this.validator,
  }) : super(key: key);

  @override
  State<InputSelected> createState() => _InputSelectedState<T>();
}

class _InputSelectedState<T> extends State<InputSelected> {
  final double radius = 10;
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.future,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          widget.items = snapshot.data as List<T>;
          return _getDropdown(context);
        } else if (snapshot.hasError) {
          return _getDropdown(context);
        } else {
          return InputText(
            placeholder: widget.placeholder,
            icon: widget.icon,
            isReadOnly: true,
            width: widget.width,
          );
        }
      },
    );
  }

  Widget _getDropdown(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => isFocus = hasFocus),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: DropdownButtonFormField<T>(
            items: _getItems(),
            value: _getValue(),
            validator: widget.validator,
            onChanged: widget.onChanged,
            isExpanded: true,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              fillColor:
                  (widget.isReadOnly) ? Theme.of(context).disabledColor : null,
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
    if (isFocus && !widget.isReadOnly) {
      return Theme.of(context).cursorColor;
    }
    return Theme.of(context).hintColor;
  }

  List<DropdownMenuItem<T>> _getItems() {
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

  T? _getValue() {
    List<DropdownMenuItem<T>> list = [];
    for (T value in widget.items) {
      if (value == widget.value) {
        return value;
      }
    }
    return null;
  }
}
