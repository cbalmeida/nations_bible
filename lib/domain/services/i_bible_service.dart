import '../models/book.dart';
import '../models/book_mark.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import '../models/version.dart';

abstract class IBibleService {
  //#region Version

  Version get version;

  set version(Version value);

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

  //#region BookMark

  Future<bool> saveBookMark({required BookMark bookMark});

  Future<bool> addVerseToBookMark({required BookMark bookMark, required Verse verse});

  Future<List<BookMark>> getAllBookMarks();

  Future<BookMark> getBookMark({required String bookMarkId});

  Future<List<Verse>> getVersesByBookMark({required String bookMarkId});

  Future<List<BookMark>> getBookMarksFromVerse({required Verse verse});

  Future<bool> isVerseAssociatedToBookMark({required BookMark bookMark, required Verse verse});

  Future<bool> toggleAssociationVerseToBookMark({required BookMark bookMark, required Verse verse});

//#endregion
}
