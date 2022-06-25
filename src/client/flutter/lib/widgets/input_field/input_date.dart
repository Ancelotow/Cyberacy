import 'package:flutter/material.dart';
import '../../models/enums/position_input.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  final String placeholder;
  final PositionInput position;
  DateTime? value;
  final bool isReadOnly;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final IconData? icon;

  InputDate({
    Key? key,
    required this.placeholder,
    this.isReadOnly = false,
    this.value,
    this.controller,
    this.width,
    this.height,
    this.position = PositionInput.middle,
    this.icon,
  }) : super(key: key);

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  final double radius = 10;

  FloatingLabelBehavior labelBehavior = FloatingLabelBehavior.auto;
  bool isFocus = false;

  get selectedDate => null;

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
            onTap: () => openCalendar(context),
            controller: widget.controller,
            readOnly: true,
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
    if(isFocus) {
      return Theme.of(context).cursorColor;
    }
    return Theme.of(context).hintColor;
  }

  Future<void> openCalendar(BuildContext context) async {
    DateTime initialDate =
        (widget.value == null) ? DateTime.now() : widget.value!;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime(2029, 1, 1),
    );
    if (picked != null) {
      widget.value = picked;
      widget.controller?.text =
          DateFormat("dd/MM/yyyy HH:mm").format(widget.value!);
    }
  }
}
