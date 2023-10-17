import 'package:flutter/material.dart';

class ColorDropDown extends StatelessWidget {
  final Color? selectedColor;
  final List<Color> colors;
  final Function(Color) onChanged;
  const ColorDropDown({
    super.key,
    required this.selectedColor,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Color?>(
      alignment: AlignmentDirectional.centerEnd,
      isExpanded: true,
      value: selectedColor,
      onChanged: (color) => onChanged(color ?? Colors.transparent),
      items: colors.map<DropdownMenuItem<Color>>((Color color) => DropdownMenuItem<Color>(value: color, child: Icon(Icons.bookmark, color: color))).toList(),
    );
  }
}
