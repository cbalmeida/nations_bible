import 'package:flutter/cupertino.dart';
import 'package:nations_bible/domain/models/book_mark.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uuid/v4.dart';

import '../../../domain/models/verse.dart';
import '../../../domain/services/i_bible_service.dart';

class MarkerController extends ChangeNotifier {
  IBibleService service;

  MarkerController(this.service) {
    titleEditController.addListener(_saveSelectedBookMark);
    descriptionEditController.addListener(_saveSelectedBookMark);
    _loadBookMarkers().then((value) => setBookMark(bookMarkers.firstOrNull));
  }

  @override
  void dispose() {
    titleEditController.removeListener(_saveSelectedBookMark);
    descriptionEditController.removeListener(_saveSelectedBookMark);
    super.dispose();
  }

  bool _isSettingController = false;
  final TextEditingController titleEditController = TextEditingController();
  final TextEditingController descriptionEditController = TextEditingController();

  final ItemScrollController itemScrollController = ItemScrollController();

  String getBookName(int bookNumber) {
    return service.version.language.bookInfos[bookNumber]?.languageBookName ?? "";
  }

  final Map<String, BookMark> _bookMarkers = {};

  List<BookMark> get bookMarkers => _bookMarkers.values.toList();

  Future<bool> _loadBookMarkers() async {
    List<BookMark> bookMarkers = await service.getAllBookMarks();
    _bookMarkers.clear();
    for (var element in bookMarkers) {
      _bookMarkers[element.id] = element;
    }
    notifyListeners();
    return true;
  }

  BookMark? selectedBookMark;

  setSelectedBookMarkColor(Color color) {
    selectedBookMark?.color = color;
    notifyListeners();
  }

  Future<bool> setBookMark(BookMark? bookMark) async {
    _isSettingController = true;
    selectedBookMark = bookMark;
    titleEditController.text = bookMark?.title ?? "";
    descriptionEditController.text = bookMark?.description ?? "";
    _isSettingController = false;
    _bookMarkers[selectedBookMark!.id] = selectedBookMark!;
    return _loadVerses();
  }

  newBookMark() {
    setBookMark(BookMark.fromValues(id: const UuidV4().generate(), title: "", description: "", colorValue: 0));
  }

  _saveSelectedBookMark() {
    if (_isSettingController) return;
    if (selectedBookMark == null) return;
    if (selectedBookMark!.title == titleEditController.text && selectedBookMark!.description == descriptionEditController.text) return;
    _bookMarkers[selectedBookMark!.id] = selectedBookMark!;
    selectedBookMark!.title = titleEditController.text;
    selectedBookMark!.description = descriptionEditController.text;
    service.saveBookMark(bookMark: selectedBookMark!);
    notifyListeners();
  }

  List<Verse> verses = [];

  Future<bool> _loadVerses() async {
    verses = await service.getVersesByBookMark(bookMarkId: selectedBookMark?.id ?? "");
    notifyListeners();
    return true;
  }

  Future<bool> isVerseAssociatedToBookMark(Verse verse, BookMark bookMark) {
    return service.isVerseAssociatedToBookMark(bookMark: bookMark, verse: verse);
  }

  Future<bool> toggleAssociationVerseToBookMark(Verse verse, BookMark bookMark) async {
    await service.toggleAssociationVerseToBookMark(bookMark: bookMark, verse: verse);
    await _loadVerses();
    return true;
  }

  Future<List<BookMark>> getBookMarksFromVerse(Verse verse) async {
    return service.getBookMarksFromVerse(verse: verse);
  }
}
