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

  InputDate({
    Key? key,
    required this.placeholder,
    this.isReadOnly = false,
    this.value,
    this.controller,
    this.width,
    this.height,
    this.position = PositionInput.middle,
  }) : super(key: key);

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  final double radius = 10;

  FloatingLabelBehavior labelBehavior = FloatingLabelBehavior.auto;

  get selectedDate => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: TextField(
        onTap: () => openCalendar(context),
        controller: widget.controller,
        readOnly: true,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          fillColor: (widget.isReadOnly)
              ? Theme.of(context).disabledColor
              : Colors.white,
          floatingLabelBehavior: labelBehavior,
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

  Future<void> openCalendar(BuildContext context) async {
    DateTime initialDate = (widget.value == null) ? DateTime.now() : widget.value!;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime(2029, 1, 1),
    );
    if(picked != null) {
      widget.value = picked;
      widget.controller?.text = DateFormat("dd/MM/yyyy HH:mm").format(widget.value!);
    }
  }
}
