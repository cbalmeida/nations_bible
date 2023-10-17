import 'package:flutter/material.dart';

import '../../../domain/models/verse.dart';
import '../text/highlight_text.dart';

class SearchedVerseListTile extends StatelessWidget {
  final String searchedString;
  final Verse verse;
  final String bookName;
  final Function() onTap;
  const SearchedVerseListTile({
    super.key,
    required this.searchedString,
    required this.verse,
    required this.bookName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Stack(
        children: [
          HighlightText(text: "${" " * (verse.verseNumber.toString().length)}   ${verse.verseText}", style: const TextStyle(fontSize: 26), highlightText: searchedString),
          Text("${verse.verseNumber}", style: const TextStyle(fontSize: 26, color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
        ],
      ),
      subtitle: Text("$bookName ${verse.chapterNumber}"),
    );
  }
}
