import 'package:flutter/material.dart';

class DraggableTarget<T> extends StatefulWidget {
  final Function(T)? callback;
  final Color color;
  final Color colorEnter;
  final double width;
  final String? label;
  final Icon? icon;

  const DraggableTarget({
    Key? key,
    this.label,
    this.icon,
    this.callback,
    this.color = Colors.grey,
    this.colorEnter = Colors.grey,
    this.width = 200,
  }) : super(key: key);

  @override
  State<DraggableTarget<T>> createState() => _DraggableTargetState<T>();
}

class _DraggableTargetState<T> extends State<DraggableTarget<T>> {
  double? currentWidth;
  Color? currentColor;

  @override
  Widget build(BuildContext context) {
    currentWidth ??= widget.width;
    currentColor ??= widget.color;
    return DragTarget(
      onAccept: (value) => widget.callback?.call(value as T),
      onWillAccept: _onWillLeave,
      onLeave: _onLeave,
      builder: (context, candidates, rejects) {
        return Container(
          width: currentWidth,
          height: currentWidth,
          decoration: BoxDecoration(
            color: currentColor,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getIconWidget(context),
              _getLabelWidget(context),
            ],
          ),
        );
      },
    );
  }

  Widget _getLabelWidget(BuildContext context) {
    if (widget.label == null) {
      return Container();
    }
    return Text(
      widget.label!,
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.clip,
      style: Theme.of(context).textTheme.headline3,
    );
  }

  Widget _getIconWidget(BuildContext context) {
    if (widget.icon == null) {
      return Container();
    }
    return widget.icon!;
  }

  void _onLeave(Object? item) {
    setState(() {
      currentWidth = widget.width;
      currentColor = widget.color;
    });
  }

  bool _onWillLeave(Object? item) {
    setState(() {
      currentWidth = widget.width * 1.20;
      currentColor = widget.colorEnter;
    });
    return true;
  }

}
