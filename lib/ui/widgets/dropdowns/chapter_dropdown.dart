import 'package:flutter/material.dart';

class ChapterDropDown extends StatelessWidget {
  final int? selectedChapter;
  final int chaptersSize;
  final Function(int?) onChanged;
  final String? Function(int) getChapterTitle;
  const ChapterDropDown({
    super.key,
    required this.selectedChapter,
    required this.chaptersSize,
    required this.onChanged,
    required this.getChapterTitle,
  });

  @override
  Widget build(BuildContext context) {
    List<int> chapters = List<int>.generate(chaptersSize, (index) => index + 1);
    return DropdownButton<int?>(
      alignment: AlignmentDirectional.centerEnd,
      isExpanded: true,
      value: selectedChapter,
      onChanged: onChanged,
      items: chapters
          .map<DropdownMenuItem<int>>(
            (int chapter) => DropdownMenuItem<int>(
              value: chapter,
              child: Text("$chapter: ${getChapterTitle(chapter) ?? ''}", style: TextStyle(fontSize: 14, fontWeight: chapter == selectedChapter ? FontWeight.bold : null)),
            ),
          )
          .toList(),
    );
  }
}
