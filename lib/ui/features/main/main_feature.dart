import 'package:flutter/material.dart';
import 'package:nations_bible/infra/services/bible_service.dart';

import '../../../domain/models/verse.dart';
import '../../widgets/sheets/verse_options/verse_options_sheet.dart';
import '../marker/marker_controller.dart';
import '../marker/marker_feature.dart';
import '../reader/reader_controller.dart';
import '../reader/reader_feature.dart';
import '../searcher/searcher_controller.dart';
import '../searcher/searcher_feature.dart';

class MainFeature extends StatefulWidget {
  const MainFeature({super.key});

  @override
  State<MainFeature> createState() => _MainFeatureState();
}

class _MainFeatureState extends State<MainFeature> {
  late final MarkerController markerController = MarkerController(BibleService.instance);
  late final ReaderController readerController = ReaderController(BibleService.instance);
  late final SearcherController searcherController = SearcherController(BibleService.instance);

  late final List<Widget> _children = [
    ReaderFeature(readerController: readerController, markerController: markerController, onTapVerse: _showVerseOptions),
    MarkerFeature(markerController: markerController, onTapVerse: _showVerseInReader),
    SearcherFeature(searcherController: searcherController, onTapVerse: _showVerseInReader),
  ];

  late final List<BottomNavigationBarItem> _buttons = [
    const BottomNavigationBarItem(activeIcon: Icon(Icons.menu_book, color: Colors.yellow), icon: Icon(Icons.menu_book), label: "Bible", backgroundColor: Colors.black),
    const BottomNavigationBarItem(activeIcon: Icon(Icons.bookmark, color: Colors.yellow), icon: Icon(Icons.bookmark), label: "BookMarks", backgroundColor: Colors.black),
    const BottomNavigationBarItem(activeIcon: Icon(Icons.search, color: Colors.yellow), icon: Icon(Icons.search), label: "Search", backgroundColor: Colors.black),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: _buttons,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }

  _showVerseInReader(Verse verse) {
    setState(() {
      currentIndex = 0;
      readerController.goToVerse(verse);
    });
  }

  _showVerseOptions(Verse verse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) => VerseOptionsSheet(verse: verse, markerController: markerController),
    );
  }
}
