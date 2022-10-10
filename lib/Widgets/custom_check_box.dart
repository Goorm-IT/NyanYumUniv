import 'package:flutter/material.dart';

class MyCustomCheckbox extends StatefulWidget {
  final Function onChange;
  final bool isChecked;
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color borderColor;

  MyCustomCheckbox({
    required this.isChecked,
    required this.onChange,
    required this.size,
    required this.iconSize,
    required this.selectedColor,
    required this.selectedIconColor,
    required this.borderColor,
  });

  @override
  _MyCustomCheckboxState createState() => _MyCustomCheckboxState();
}

class _MyCustomCheckboxState extends State<MyCustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isSelected = widget.isChecked;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChange(_isSelected);
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.all(4),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: _isSelected ? widget.selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: widget.borderColor,
              width: 2.0,
            )),
        width: widget.size,
        height: widget.size,
        child: _isSelected
            ? Icon(
                Icons.check,
                color: widget.selectedIconColor,
                size: widget.iconSize,
              )
            : Container(),
      ),
    );
  }
}
