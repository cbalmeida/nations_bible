import 'package:flutter/material.dart';

class ChapterDropDown extends StatelessWidget {
  final int? selectedChapter;
  final int chaptersSize;
  final Function(int?) onChanged;
  const ChapterDropDown({
    super.key,
    required this.selectedChapter,
    required this.chaptersSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<int> chapters = List<int>.generate(chaptersSize, (index) => index + 1);
    return DropdownButton<int?>(
      value: selectedChapter,
      onChanged: onChanged,
      items: chapters.map<DropdownMenuItem<int>>((int chapter) => DropdownMenuItem<int>(value: chapter, child: Text(chapter.toString()))).toList(),
    );
  }
}
