import 'package:flutter/material.dart';

import '../../domain/models/verse.dart';

class VerseListTile extends StatelessWidget {
  final Verse verse;
  const VerseListTile({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${verse.verseNumber}   ${verse.verseText}", style: const TextStyle(fontSize: 20)),
    );
  }
}
