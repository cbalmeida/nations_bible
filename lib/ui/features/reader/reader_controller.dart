import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../domain/models/book.dart';
import '../../../domain/models/verse.dart';
import '../../../domain/models/version.dart';
import '../../../domain/services/i_bible_service.dart';

class ReaderController extends ChangeNotifier {
  IBibleService service;

  ReaderController(this.service) {
    _loadBooks().then((value) => setBook(books[0]));
  }

  //#region Version

  List<Version> get versions => Version.versions;

  Version get selectedVersion => service.version;

  setVersion(Version? version) async {
    if (version == null) return;
    service.version = version;
    _loadBooks().then((value) => setBook(books[(selectedBook?.bookNumber ?? 1) - 1], chapter: selectedChapterNumber, scrollToFirstVerse: false));
  }

  //#endregion

  //#region Books

  List<Book> books = [];
  Book? selectedBook;

  Future<bool> setBook(Book? book, {int? chapter = 1, bool? scrollToFirstVerse = true}) async {
    selectedBook = book;
    return setChapter(chapter, scrollToFirstVerse: scrollToFirstVerse);
  }

  Future<bool> _loadBooks() async {
    books = await service.getAllBooks();
    notifyListeners();
    return true;
  }

  void navigatePreviousBook() {
    if (selectedBook?.bookNumber == 1) return;
    Book previousBook = books[(selectedBook?.bookNumber ?? 1) - 2];
    setBook(previousBook, chapter: previousBook.chaptersSize);
  }

  void navigateNextBook() {
    if (selectedBook?.bookNumber == books.length) return;
    Book nextBook = books[(selectedBook?.bookNumber ?? 1)];
    setBook(nextBook, chapter: 1);
  }

  //#endregion

  //#region Chapters

  int selectedChapterNumber = 1;

  Future<bool> setChapter(int? chapterNumber, {bool? scrollToFirstVerse}) async {
    selectedChapterNumber = chapterNumber ?? 1;
    return _loadVerses();
  }

  String? getChapterTitle(int? chapterNumber) {
    if (chapterNumber == null) return null;
    return selectedBook?.getChapterTitle(chapterNumber);
  }

  void navigatePreviousChapter() {
    if (selectedChapterNumber == 1) {
      navigatePreviousBook();
    } else {
      setChapter(selectedChapterNumber - 1);
    }
  }

  void navigateNextChapter() {
    if (selectedChapterNumber == selectedBook?.chaptersSize) {
      navigateNextBook();
    } else {
      setChapter(selectedChapterNumber + 1);
    }
  }

  //#endregion

  //#region Verses

  List<Verse> verses = [];

  int selectedVerse = 1;
  void setSelectedVerse(int? verseNumber) {
    selectedVerse = verseNumber ?? 1;
    scrollToVerseIndex(verseNumber ?? 1);
    notifyListeners();
  }

  late final ItemScrollController itemScrollController = ItemScrollController();

  Future<bool> _loadVerses({bool? scrollToFirstVerse}) async {
    verses = await service.getVersesByBookChapter(bookNumber: selectedBook?.bookNumber ?? 1, chapterNumber: selectedChapterNumber);
    if (scrollToFirstVerse ?? false) scrollToVerseIndex(1);
    notifyListeners();
    return true;
  }

  Future<bool> goToVerse(Verse verse) async {
    await setBook(books[verse.bookNumber - 1]);
    await setChapter(verse.chapterNumber);
    Future.delayed(const Duration(milliseconds: 200), () => itemScrollController.scrollTo(index: verse.verseNumber - 1, duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic));
    return true;
  }

  Future<bool> scrollToVerseIndex(int verseNumber) async {
    selectedVerse = verseNumber;
    Future.delayed(const Duration(milliseconds: 100), () => itemScrollController.scrollTo(index: verseNumber - 1, duration: const Duration(milliseconds: 100), curve: Curves.easeInOutCubic));
    return true;
  }

  //#endregion
}
