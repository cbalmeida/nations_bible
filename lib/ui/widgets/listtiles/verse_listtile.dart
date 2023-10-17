import 'package:flutter/material.dart';

import '../../../domain/models/book_mark.dart';
import '../../../domain/models/verse.dart';

class VerseListTile extends StatelessWidget {
  final Verse verse;
  final Function() onTap;
  final Future<List<BookMark>> Function(Verse) getBookMarksFromVerse;
  const VerseListTile({
    super.key,
    required this.verse,
    required this.onTap,
    required this.getBookMarksFromVerse,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Stack(
        children: [
          Text("${" " * (verse.verseNumber.toString().length)}   ${verse.verseText}", style: const TextStyle(fontSize: 26)),
          Text("${verse.verseNumber}", style: const TextStyle(fontSize: 26, color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
        ],
      ),
      trailing: FutureBuilder<List<BookMark>>(
          future: getBookMarksFromVerse(verse),
          builder: (context, snapShot) {
            List<BookMark> bookMarks = snapShot.data ?? [];
            return bookMarks.isEmpty ? const SizedBox.shrink() : Icon(Icons.bookmark, color: bookMarks.first.color);
          }),
    );
  }
}
