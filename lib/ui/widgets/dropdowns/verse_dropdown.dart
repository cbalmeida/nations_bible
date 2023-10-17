import 'package:flutter/material.dart';

class VerseDropDown extends StatelessWidget {
  final int? selectedVerse;
  final int versesSize;
  final Function(int?) onChanged;
  const VerseDropDown({
    super.key,
    required this.selectedVerse,
    required this.versesSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<int> chapters = List<int>.generate(versesSize, (index) => index + 1);
    return DropdownButton<int?>(
      alignment: AlignmentDirectional.centerEnd,
      isExpanded: true,
      value: selectedVerse,
      onChanged: onChanged,
      items: chapters
          .map<DropdownMenuItem<int>>(
            (int verse) => DropdownMenuItem<int>(
              value: verse,
              child: Center(child: Text("$verse", style: TextStyle(fontSize: 14, fontWeight: verse == selectedVerse ? FontWeight.bold : null))),
            ),
          )
          .toList(),
    );
  }
}
