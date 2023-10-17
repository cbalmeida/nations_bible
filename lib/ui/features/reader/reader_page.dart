import 'package:flutter/material.dart';
import 'package:nations_bible/ui/features/reader/reader_controller.dart';
import 'package:nations_bible/ui/widgets/dropdowns/book_dropdown.dart';
import 'package:nations_bible/ui/widgets/dropdowns/chapter_dropdown.dart';
import 'package:nations_bible/ui/widgets/dropdowns/version_dropdown.dart';
import 'package:nations_bible/ui/widgets/listtiles/chapter_navigation_listtile.dart';
import 'package:nations_bible/ui/widgets/listtiles/verse_listtile.dart';

import '../../../domain/models/verse.dart';
import '../../widgets/dropdowns/verse_dropdown.dart';
import '../../widgets/lists/custom_listview.dart';
import '../marker/marker_controller.dart';

class ReaderPage extends StatelessWidget {
  final ReaderController readerController;
  final MarkerController markerController;
  final Function(Verse verse) onTapVerse;
  const ReaderPage({
    super.key,
    required this.readerController,
    required this.markerController,
    required this.onTapVerse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(flex: 2, child: VersionDropDown(selectedVersion: readerController.selectedVersion, versions: readerController.versions, onChanged: readerController.setVersion)),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: BookDropDown(books: readerController.books, selectedBook: readerController.selectedBook, onChanged: readerController.setBook)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(flex: 7, child: ChapterDropDown(selectedChapter: readerController.selectedChapterNumber, onChanged: readerController.setChapter, chaptersSize: readerController.selectedBook?.chaptersSize ?? 1, getChapterTitle: readerController.getChapterTitle)),
                Expanded(flex: 1, child: VerseDropDown(selectedVerse: readerController.selectedVerse, versesSize: readerController.verses.length, onChanged: readerController.setSelectedVerse)),
              ],
            ),
          ),
        ),
      ),
      body: CustomListView(
        itemScrollController: readerController.itemScrollController,
        itemCount: readerController.verses.length + 1,
        itemBuilder: _itemBuilder,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index == readerController.verses.length) {
      return ChapterNavigationListTile(onTapPrevious: readerController.navigatePreviousChapter, onTapNext: readerController.navigateNextChapter);
    } else {
      return VerseListTile(
        verse: readerController.verses[index],
        onTap: () => onTapVerse(readerController.verses[index]),
        getBookMarksFromVerse: markerController.getBookMarksFromVerse,
      );
    }
  }
}
