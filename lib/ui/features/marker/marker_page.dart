import 'package:flutter/material.dart';
import 'package:nations_bible/ui/features/marker/marker_edit_page.dart';
import 'package:nations_bible/ui/widgets/lists/custom_listview.dart';

import '../../../domain/models/verse.dart';
import '../../widgets/dropdowns/book_mark_dropdown.dart';
import '../../widgets/listtiles/searched_verse_listtile.dart';
import 'marker_controller.dart';

class MarkerPage extends StatelessWidget {
  final MarkerController controller;
  final Function(Verse verse) onTapVerse;
  const MarkerPage({super.key, required this.controller, required this.onTapVerse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(flex: 1, child: IconButton(onPressed: controller.newBookMark, icon: const Icon(Icons.add))),
            Expanded(flex: 6, child: BookMarkDropDown(selectedBookMark: controller.selectedBookMark, bookMarks: controller.bookMarkers, onChanged: controller.setBookMark)),
            Expanded(flex: 1, child: IconButton(onPressed: () => _editBookMark(context), icon: const Icon(Icons.edit))),
            Expanded(flex: 1, child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete))),
          ],
        ),
      ),
      body: (controller.selectedBookMark == null)
          ? const Center(child: Text("No BookMark Selected"))
          : CustomListView(
              itemScrollController: controller.itemScrollController,
              itemCount: controller.verses.length,
              itemBuilder: (context, index) => SearchedVerseListTile(
                verse: controller.verses[index],
                searchedString: "",
                bookName: controller.getBookName(controller.verses[index].bookNumber),
                onTap: () => onTapVerse(controller.verses[index]),
              ),
            ),
    );
  }

  _editBookMark(BuildContext context) => MarkerEditPage.showPage(context, controller);
}

// ColorDropDown(selectedColor: controller.selectedBookMark?.color, colors: BookMark.colors, onChanged: controller.setSelectedBookMarkColor),
// TextField(controller: controller.titleEditController, decoration: const InputDecoration(hintText: "Title", border: UnderlineInputBorder())),
// TextField(controller: controller.descriptionEditController, decoration: const InputDecoration(hintText: "Description", border: UnderlineInputBorder())),
