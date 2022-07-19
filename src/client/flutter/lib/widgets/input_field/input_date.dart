import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  final String placeholder;
  DateTime? value;
  final bool isReadOnly;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final IconData? icon;
  final String? Function(String?)? validator;

  InputDate({
    Key? key,
    required this.placeholder,
    this.isReadOnly = false,
    this.value,
    this.controller,
    this.width,
    this.height,
    this.icon,
    this.validator
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
          child: TextFormField(
            validator: widget.validator,
            onTap: () => openCalendar(context),
            controller: widget.controller,
            readOnly: true,
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

  Future<void> openCalendar(BuildContext context) async {
    DateTime initialDate =
        (widget.value == null) ? DateTime.now() : widget.value!;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      initialEntryMode: DatePickerEntryMode.calendar,
      firstDate: DateTime(1900, 1, 1, 0, 0),
      lastDate: DateTime(2050, 1, 1, 0, 0),
    );
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (picked != null && selectedTime != null) {
      widget.value = DateTime(picked.year, picked.month, picked.day, selectedTime.hour, selectedTime.minute);
      widget.controller?.text =
          DateFormat("dd/MM/yyyy HH:mm").format(widget.value!);
    }
  }
}
