import 'package:flutter/material.dart';
import 'package:nations_bible/ui/features/marker/marker_controller.dart';
import 'package:nations_bible/ui/widgets/sheets/verse_options/verse_options_sheet_bookmarks.dart';

import '../../../../domain/models/verse.dart';

class VerseOptionsSheet extends StatefulWidget {
  final Verse verse;
  final MarkerController markerController;
  const VerseOptionsSheet({
    super.key,
    required this.verse,
    required this.markerController,
  });

  @override
  State<VerseOptionsSheet> createState() => _VerseOptionsSheetState();
}

class _VerseOptionsSheetState extends State<VerseOptionsSheet> {
  late final List<Widget> _children = [
    VerseOptionsSheetBookMarks(verse: widget.verse, markerController: widget.markerController),
    const Text("Page 2"),
    const Text("Page 3"),
  ];

  late final List<BottomNavigationBarItem> _buttons = [
    const BottomNavigationBarItem(activeIcon: Icon(Icons.bookmark, color: Colors.yellow), icon: Icon(Icons.bookmark), label: "", backgroundColor: Colors.black),
    const BottomNavigationBarItem(activeIcon: Icon(Icons.share, color: Colors.yellow), icon: Icon(Icons.search), label: "", backgroundColor: Colors.black),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Scaffold(
        body: _children[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: _buttons,
          onTap: (index) => setState(() => currentIndex = index),
        ),
      ),
    );
  }
}
