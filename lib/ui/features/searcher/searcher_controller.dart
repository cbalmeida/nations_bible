import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../domain/models/verse.dart';
import '../../../domain/services/i_bible_service.dart';

class SearcherController extends ChangeNotifier {
  IBibleService service;

  SearcherController(this.service) {
    searchController.addListener(_loadVerses);
  }

  @override
  void dispose() {
    searchController.removeListener(_loadVerses);
    super.dispose();
  }

  late TextEditingController searchController = TextEditingController();

  List<Verse> verses = [];

  final ItemScrollController itemScrollController = ItemScrollController();

  String getBookName(int bookNumber) {
    return service.version.language.bookInfos[bookNumber]?.languageBookName ?? "";
  }

  String getSummary() {
    String searchText = searchController.text;
    if (searchText.length <= 2) return "Type at least 3 characters";
    int totalBooks = verses.map((e) => e.bookNumber).toSet().length;
    int totalChapters = verses.map((e) => (e.bookNumber * 1000 + e.chapterNumber)).toSet().length;
    int totalVerses = verses.length;
    return "$totalBooks books, $totalChapters chapters and $totalVerses verses found";
  }

  _loadVerses() async {
    String searchText = searchController.text;
    if (searchText.length <= 2) {
      verses = [];
      notifyListeners();
      return;
    }
    verses = await service.searchVerseByText(verseTextContains: searchController.text);
    notifyListeners();
  }
}
