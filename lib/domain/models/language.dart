part 'language_english.dart';
part 'language_portuguese.dart';

abstract class Language {
  String get languageLongName;
  String get languageShortName;
  Map<int, LanguageBookInfo> get bookInfos;

  LanguageBookInfo getLanguageBookInfo(int bookNumber) => bookInfos[bookNumber] ?? LanguageBookInfo(languageBookName: "", languageBookAbbreviation: "", languageChapterInfos: []);
}

class LanguageBookInfo {
  final String languageBookName;
  final String languageBookAbbreviation;
  final List<LanguageChapterInfo> languageChapterInfos;

  LanguageBookInfo({
    required this.languageBookName,
    required this.languageBookAbbreviation,
    required this.languageChapterInfos,
  });
}

class LanguageChapterInfo {
  final String languageChapterTitle;

  LanguageChapterInfo({
    required this.languageChapterTitle,
  });
}
