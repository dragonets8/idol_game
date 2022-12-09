import 'package:flutter/material.dart';

///Widget that draw a beautiful checkbox rounded. Provided with animation if wanted
class XCheckBox extends StatefulWidget {
  const XCheckBox({
    Key key,
    this.isChecked,
    this.checkedWidget,
    this.uncheckedWidget,
    this.size,
    this.animationDuration,
    this.onTap,
  }) : super(key: key);

  ///Define wether the checkbox is marked or not
  final bool isChecked;

  ///Define the widget that is shown when Widgets is checked
  final Widget checkedWidget;

  ///Define the widget that is shown when Widgets is unchecked
  final Widget uncheckedWidget;

  ///Define the size of the checkbox
  final double size;

  ///Define Function that os executed when user tap on checkbox
  ///If onTap is given a null callack, it will be disabled
  final Function(bool) onTap;

  ///Define the duration of the animation. If any
  final Duration animationDuration;

  @override
  _XCheckBoxState createState() => _XCheckBoxState();
}

class _XCheckBoxState extends State<XCheckBox> {
  bool isChecked;
  Duration animationDuration;
  double size;
  Widget checkedWidget;
  Widget uncheckedWidget;

  @override
  void initState() {
    isChecked = widget.isChecked ?? false;
    animationDuration = widget.animationDuration ?? Duration(milliseconds: 500);
    size = widget.size ?? 30.0;
    checkedWidget =
        widget.checkedWidget ?? Icon(Icons.check, color: Colors.transparent);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    super.initState();
  }

  @override
  void didUpdateWidget(XCheckBox oldWidget) {
    if (isChecked != widget.isChecked) {
      isChecked = widget.isChecked ?? false;
    }
    if (animationDuration != widget.animationDuration) {
      animationDuration =
          widget.animationDuration ?? Duration(milliseconds: 500);
    }
    if (size != widget.size) {
      size = widget.size ?? 40.0;
    }
    if (checkedWidget != widget.checkedWidget) {
      checkedWidget =
          widget.checkedWidget ?? Icon(Icons.check, color: Colors.white);
    }
    if (uncheckedWidget != widget.uncheckedWidget) {
      uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.onTap != null
        ? GestureDetector(
            onTap: () {
              setState(() => isChecked = !isChecked);
              widget.onTap(isChecked);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: AnimatedContainer(
                duration: animationDuration,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 2),
                ),
                child: isChecked ? checkedWidget : uncheckedWidget,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: AnimatedContainer(
              duration: animationDuration,
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: isChecked ? checkedWidget : uncheckedWidget,
            ),
          );
  }
}
