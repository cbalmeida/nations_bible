import '../models/book.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import '../models/version.dart';

abstract class IService {
  //#region Version

  Version? version;

  //#endregion

  //#region Book

  Future<Book> getBook({required int bookNumber});

  Future<List<Book>> searchBooksByName({required String bookNameContains});

  Future<List<Book>> getAllBooks();

  //#endregion

  //#region Chapter

  Future<Chapter> getChapter({required int bookNumber, required int chapterNumber});

  Future<List<Chapter>> getChaptersByBook({required int bookNumber});

  Future<List<Chapter>> getAllChapters();

  //#endregion

  //#region Verse

  Future<Verse> getVerse({required int bookNumber, required int chapterNumber, required int verseNumber});

  Future<List<Verse>> getVersesByBookChapter({required int bookNumber, required int chapterNumber});

  Future<List<Verse>> searchVerseByText({required String verseTextContains});

  Future<List<Verse>> getAllVerses();

  //#endregion
}
