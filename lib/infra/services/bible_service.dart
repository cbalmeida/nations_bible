import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:nations_bible/domain/models/book.dart';
import 'package:nations_bible/domain/models/chapter.dart';
import 'package:nations_bible/domain/models/verse.dart';
import 'package:nations_bible/domain/services/i_bible_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/book_mark.dart';
import '../../domain/models/version.dart';

class BibleService extends IBibleService {
  BibleService._();

  static final BibleService instance = BibleService._();

  //#region Store

  // bible

  Database? _databaseBible;

  Future<Database> get _dbBible async => _databaseBible ??= await _openDatabaseBible();

  Future<Database> _openDatabaseBible() async {
    io.Directory applicationDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(applicationDirectory.path, version.fileName);
    bool dbPathExists = await io.File(dbPath).exists();
    if (!dbPathExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(path.join("assets", "versions", version.fileName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await io.File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(dbPath);
  }

  // book marks

  Database? _databaseBookMarks;

  Future<Database> get _dbBookMarks async => _databaseBookMarks ??= await _openDatabaseBookMarks();

  Future<Database> _openDatabaseBookMarks() async {
    io.Directory applicationDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(applicationDirectory.path, "bookmarks.sqlite");
    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) => _onUpgradeDatabaseBookMarks(db),
      onUpgrade: (db, oldVersion, newVersion) => _onUpgradeDatabaseBookMarks(db),
    );
  }

  _onUpgradeDatabaseBookMarks(Database db) async {
    await db.execute("create table if not exists bookmarks (id text primary key, title text, description text)");
    await db.execute("create table if not exists bookmarks_verses (bookMarkId text, book integer, chapter integer, verse integer, primary key (bookMarkId, book, chapter, verse), foreign key (bookMarkId) references bookmarks (id) on delete cascade)");
    bool columnColorExistsInBookMarks = await _columExistsInTable(db, "bookmarks", "color");
    if (!columnColorExistsInBookMarks) await db.execute("alter table bookmarks add column color integer");
  }

  Future<bool> _columExistsInTable(Database db, String tableName, String columnName) async {
    List<Map<String, Object?>> result = await db.rawQuery("pragma table_info($tableName)");
    return result.any((element) => element["name"] == columnName);
  }

  // shared prefs

  SharedPreferences? _sharedPrefs;

  Future<SharedPreferences> get _prefs async => _sharedPrefs ??= await _openSharedPreferences();

  Future<SharedPreferences> _openSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  //#endregion

  //#region Version

  Version _version = Version.almeida_ra;

  @override
  Version get version => _version;

  @override
  set version(Version value) {
    _version = value;
    if (_databaseBible != null) _databaseBible!.close();
    _databaseBible = null;
    _prefs.then((prefs) => prefs.setString("bible_versionShortName", value.versionShortName));
  }

  //#endregion

  //#region Book

  @override
  Future<Book> getBook({required int bookNumber}) async {
    Database db = await _dbBible;
    List<Map<String, Object?>> chaptersSizeResult = await db.rawQuery("select count(distinct chapter) as count from verses where book = ?", [bookNumber]);
    int chaptersSize = chaptersSizeResult[0]["count"] as int;
    return Book(bookNumber: bookNumber, chaptersSize: chaptersSize, languageBookInfo: version.language.getLanguageBookInfo(bookNumber));
  }

  @override
  Future<List<Book>> searchBooksByName({required String bookNameContains}) async {
    List<Book> books = await getAllBooks();
    return books.where((book) => book.languageBookInfo.languageBookName.toLowerCase().contains(bookNameContains.toLowerCase())).toList();
  }

  @override
  Future<List<Book>> getAllBooks() async {
    List<Book> result = [];
    Database db = await _dbBible;
    List<Map<String, Object?>> booksResult = await db.rawQuery("select distinct book from verses order by book");
    for (var bookResult in booksResult) {
      int bookNumber = bookResult["book"] as int;
      result.add(await getBook(bookNumber: bookNumber));
    }
    return result;
  }

  //#endregion

  //#region Chapter

  @override
  Future<Chapter> getChapter({required int bookNumber, required int chapterNumber}) async {
    Database db = await _dbBible;
    List<Map<String, Object?>> versesSizeResult = await db.rawQuery("select count(*) as count from verses where book = ? and chapter = ?", [bookNumber, chapterNumber]);
    int versesSize = versesSizeResult[0]["count"] as int;
    return Chapter(bookNumber: bookNumber, chapterNumber: chapterNumber, versesSize: versesSize);
  }

  @override
  Future<List<Chapter>> getChaptersByBook({required int bookNumber}) async {
    List<Chapter> result = [];
    Database db = await _dbBible;
    List<Map<String, Object?>> chaptersResult = await db.rawQuery("select distinct chapter from verses where book = ? order by chapter", [bookNumber]);
    for (var chapterResult in chaptersResult) {
      int chapterNumber = chapterResult["chapter"] as int;
      result.add(await getChapter(bookNumber: bookNumber, chapterNumber: chapterNumber));
    }
    return result;
  }

  @override
  Future<List<Chapter>> getAllChapters() async {
    List<Chapter> result = [];
    Database db = await _dbBible;
    List<Map<String, Object?>> chaptersResult = await db.rawQuery("select distinct book, chapter from verses order by book, chapter");
    for (var chapterResult in chaptersResult) {
      int bookNumber = chapterResult["book"] as int;
      int chapterNumber = chapterResult["chapter"] as int;
      result.add(await getChapter(bookNumber: bookNumber, chapterNumber: chapterNumber));
    }
    return result;
  }

  //#endregion

  //#region Verse

  @override
  Future<Verse> getVerse({required int bookNumber, required int chapterNumber, required int verseNumber}) async {
    Database db = await _dbBible;
    List<Map<String, Object?>> versesResult = await db.rawQuery("select text from verses where book = ? and chapter = ? and verse = ?", [bookNumber, chapterNumber, verseNumber]);
    String verseText = (versesResult[0]["text"] as String).replaceAll('¶', "").trim();
    return Verse(bookNumber: bookNumber, chapterNumber: chapterNumber, verseNumber: verseNumber, verseText: verseText);
  }

  @override
  Future<List<Verse>> getVersesByBookChapter({required int bookNumber, required int chapterNumber}) async {
    List<Verse> result = [];
    Database db = await _dbBible;
    List<Map<String, Object?>> versesResult = await db.rawQuery("select verse, text from verses where book = ? and chapter = ? order by verse", [bookNumber, chapterNumber]);
    for (var verseResult in versesResult) {
      int verseNumber = verseResult["verse"] as int;
      String verseText = (verseResult["text"] as String).replaceAll('¶', "").trim();
      ;
      result.add(Verse(bookNumber: bookNumber, chapterNumber: chapterNumber, verseNumber: verseNumber, verseText: verseText));
    }
    return result;
  }

  @override
  Future<List<Verse>> searchVerseByText({required String verseTextContains}) async {
    List<Verse> result = [];
    Database db = await _dbBible;
    List<Map<String, Object?>> versesResult = await db.rawQuery("select book, chapter, verse, text from verses where text like '%$verseTextContains%' order by book, chapter, verse", []);
    for (var verseResult in versesResult) {
      int bookNumber = verseResult["book"] as int;
      int chapterNumber = verseResult["chapter"] as int;
      int verseNumber = verseResult["verse"] as int;
      String verseText = (verseResult["text"] as String).replaceAll('¶', "").trim();
      result.add(Verse(bookNumber: bookNumber, chapterNumber: chapterNumber, verseNumber: verseNumber, verseText: verseText));
    }
    return result;
  }

  @override
  Future<List<Verse>> getAllVerses() async {
    Database db = await _dbBible;
    List<Verse> result = [];
    List<Map<String, Object?>> versesResult = await db.rawQuery("select book, chapter, verse, text from verses order by book, chapter, verse");
    for (var verseResult in versesResult) {
      int bookNumber = verseResult["book"] as int;
      int chapterNumber = verseResult["chapter"] as int;
      int verseNumber = verseResult["verse"] as int;
      String verseText = (verseResult["text"] as String).replaceAll('¶', "").trim();
      result.add(Verse(bookNumber: bookNumber, chapterNumber: chapterNumber, verseNumber: verseNumber, verseText: verseText));
    }
    return result;
  }

  //#endregion

  //#region BookMark

  @override
  Future<bool> saveBookMark({required BookMark bookMark}) async {
    Database dbBookMarks = await _dbBookMarks;
    await dbBookMarks.transaction((txn) async {
      await txn.rawInsert("insert or replace into bookmarks (id, title, description, color) values (?, ?, ?, ?) ", [bookMark.id, bookMark.title, bookMark.description, bookMark.color.value]);
    });
    return true;
  }

  @override
  Future<bool> addVerseToBookMark({required BookMark bookMark, required Verse verse}) async {
    Database dbBookMarks = await _dbBookMarks;
    await dbBookMarks.transaction((txn) async {
      await txn.rawInsert("insert into bookmarks_verses (bookMarkId, book, chapter, verse) values (?, ?, ?, ?) on conflict (bookMarkId, book, chapter, verse) do nothing", [bookMark.id, verse.bookNumber, verse.chapterNumber, verse.verseNumber]);
    });
    return true;
  }

  @override
  Future<List<BookMark>> getAllBookMarks() async {
    Database dbBookMarks = await _dbBookMarks;
    List<BookMark> result = [];
    List<Map<String, Object?>> bookMarksResult = await dbBookMarks.rawQuery("select * from bookmarks order by title");
    for (var bookMarkResult in bookMarksResult) {
      String id = bookMarkResult["id"] as String;
      String title = bookMarkResult["title"] as String;
      String description = bookMarkResult["description"] as String;
      int colorValue = bookMarksResult[0]["color"] as int;
      BookMark bookMark = BookMark.fromValues(id: id, title: title, description: description, colorValue: colorValue);
      result.add(bookMark);
    }
    return result;
  }

  @override
  Future<BookMark> getBookMark({required String bookMarkId}) async {
    Database dbBookMarks = await _dbBookMarks;
    List<Map<String, Object?>> bookMarksResult = await dbBookMarks.rawQuery("select * from bookmarks where id = ?", [bookMarkId]);
    String title = bookMarksResult[0]["title"] as String;
    String description = bookMarksResult[0]["description"] as String;
    int colorValue = bookMarksResult[0]["color"] as int;
    BookMark bookMark = BookMark.fromValues(id: bookMarkId, title: title, description: description, colorValue: colorValue);
    return bookMark;
  }

  @override
  Future<List<Verse>> getVersesByBookMark({required String bookMarkId}) async {
    Database dbBookMarks = await _dbBookMarks;
    List<Verse> result = [];
    List<Map<String, Object?>> bookMarksVersesResult = await dbBookMarks.rawQuery("select book, chapter, verse from bookmarks_verses where bookMarkId = ? order by book, chapter, verse", [bookMarkId]);
    for (var bookMarkVerseResult in bookMarksVersesResult) {
      int bookNumber = bookMarkVerseResult["book"] as int;
      int chapterNumber = bookMarkVerseResult["chapter"] as int;
      int verseNumber = bookMarkVerseResult["verse"] as int;
      Verse verse = await getVerse(bookNumber: bookNumber, chapterNumber: chapterNumber, verseNumber: verseNumber);
      result.add(verse);
    }
    return result;
  }

  @override
  Future<List<BookMark>> getBookMarksFromVerse({required Verse verse}) async {
    Database dbBookMarks = await _dbBookMarks;
    List<BookMark> result = [];
    List<Map<String, Object?>> bookMarksResult = await dbBookMarks.rawQuery("select * from bookmarks where id in (select bookMarkId from bookmarks_verses where book = ? and chapter = ? and verse = ?) order by title", [verse.bookNumber, verse.chapterNumber, verse.verseNumber]);
    for (var bookMarkResult in bookMarksResult) {
      String id = bookMarkResult["id"] as String;
      String title = bookMarkResult["title"] as String;
      String description = bookMarkResult["description"] as String;
      int colorValue = bookMarksResult[0]["color"] as int;
      BookMark bookMark = BookMark.fromValues(id: id, title: title, description: description, colorValue: colorValue);
      result.add(bookMark);
    }
    return result;
  }

  @override
  Future<bool> isVerseAssociatedToBookMark({required BookMark bookMark, required Verse verse}) async {
    Database dbBookMarks = await _dbBookMarks;
    List<Map<String, Object?>> bookMarksResult = await dbBookMarks.rawQuery("select * from bookmarks_verses where bookMarkId = ? and book = ? and chapter = ? and verse = ?", [bookMark.id, verse.bookNumber, verse.chapterNumber, verse.verseNumber]);
    return bookMarksResult.isNotEmpty;
  }

  @override
  Future<bool> toggleAssociationVerseToBookMark({required BookMark bookMark, required Verse verse}) async {
    Database dbBookMarks = await _dbBookMarks;
    if (await isVerseAssociatedToBookMark(bookMark: bookMark, verse: verse)) {
      await dbBookMarks.transaction((txn) async => await txn.rawDelete("delete from bookmarks_verses where bookMarkId = ? and book = ? and chapter = ? and verse = ?", [bookMark.id, verse.bookNumber, verse.chapterNumber, verse.verseNumber]));
    } else {
      await dbBookMarks.transaction((txn) async => await txn.rawInsert("insert into bookmarks_verses (bookMarkId, book, chapter, verse) values (?, ?, ?, ?) on conflict (bookMarkId, book, chapter, verse) do nothing", [bookMark.id, verse.bookNumber, verse.chapterNumber, verse.verseNumber]));
    }
    return true;
  }

  //#endregion
}
