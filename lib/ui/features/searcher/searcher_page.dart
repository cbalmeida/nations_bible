import 'package:flutter/material.dart';
import 'package:nations_bible/ui/features/searcher/searcher_controller.dart';
import 'package:nations_bible/ui/widgets/lists/custom_listview.dart';

import '../../../domain/models/verse.dart';
import '../../widgets/listtiles/searched_verse_listtile.dart';

class SearcherPage extends StatelessWidget {
  final SearcherController controller;
  final Function(Verse verse) onTapVerse;
  const SearcherPage({
    super.key,
    required this.controller,
    required this.onTapVerse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: controller.searchController, decoration: const InputDecoration(hintText: "Search", border: UnderlineInputBorder(), prefixIcon: Icon(Icons.search))),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(controller.getSummary()),
          ),
        ),
      ),
      body: CustomListView(
        itemScrollController: controller.itemScrollController,
        itemCount: controller.verses.length,
        itemBuilder: (context, index) => SearchedVerseListTile(
          verse: controller.verses[index],
          searchedString: controller.searchController.text,
          bookName: controller.getBookName(controller.verses[index].bookNumber),
          onTap: () => onTapVerse(controller.verses[index]),
        ),
      ),
    );
  }
}
