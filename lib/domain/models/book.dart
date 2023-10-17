import 'package:nations_bible/domain/models/language.dart';

class Book {
  final int bookNumber;
  final LanguageBookInfo languageBookInfo;
  final int chaptersSize;

  Book({
    required this.bookNumber,
    required this.languageBookInfo,
    required this.chaptersSize,
  });

  String? getChapterTitle(int chapterNumber) {
    try {
      int index = chapterNumber - 1;
      if ((index >= chaptersSize) || (index < 0)) return null;
      return languageBookInfo.languageChapterInfos[chapterNumber - 1].languageChapterTitle;
    } catch (e) {
      return null;
    }
  }
}
