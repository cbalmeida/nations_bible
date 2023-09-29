import 'package:flutter/cupertino.dart';

import '../../domain/models/verse.dart';
import '../../domain/services/iservice.dart';

class ReaderController extends ChangeNotifier {
  IService service;

  ReaderController(this.service) {
    loadChapter(bookNumber: 1, chapterNumber: 1);
  }

  List<Verse> verses = [];

  loadChapter({required int bookNumber, required int chapterNumber}) async {
    verses = await service.getVersesByBookChapter(bookNumber: bookNumber, chapterNumber: chapterNumber);
    notifyListeners();
  }
}
