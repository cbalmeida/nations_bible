import 'package:flutter/material.dart';
import 'package:nations_bible/ui/features/marker/marker_controller.dart';

import '../../../../domain/models/book_mark.dart';
import '../../../../domain/models/verse.dart';

class VerseOptionsSheetBookMarks extends StatefulWidget {
  final Verse verse;
  final MarkerController markerController;
  const VerseOptionsSheetBookMarks({
    super.key,
    required this.verse,
    required this.markerController,
  });

  @override
  State<VerseOptionsSheetBookMarks> createState() => _VerseOptionsSheetBookMarksState();
}

class _VerseOptionsSheetBookMarksState extends State<VerseOptionsSheetBookMarks> {
  late final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.markerController,
      builder: (context, child) => Column(
        children: [
          ListTile(
            title: Text(widget.verse.verseText),
          ),
          ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: widget.markerController.bookMarkers.length,
            itemBuilder: (context, index) => VerseOptionsSheetBookMark(
              verse: widget.verse,
              bookMark: widget.markerController.bookMarkers[index],
              isBookMarkChecked: widget.markerController.isVerseAssociatedToBookMark,
              onTapBookMark: widget.markerController.toggleAssociationVerseToBookMark,
            ),
          ),
        ],
      ),
    );
  }
}

class VerseOptionsSheetBookMark extends StatelessWidget {
  final Verse verse;
  final BookMark bookMark;
  final Future<bool> Function(Verse, BookMark) isBookMarkChecked;
  final Function(Verse, BookMark) onTapBookMark;
  const VerseOptionsSheetBookMark({
    super.key,
    required this.verse,
    required this.bookMark,
    required this.isBookMarkChecked,
    required this.onTapBookMark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.bookmark, color: bookMark.color),
      title: Text(bookMark.title),
      subtitle: Text(bookMark.description),
      onTap: () => onTapBookMark(verse, bookMark),
      trailing: FutureBuilder<bool>(
        future: isBookMarkChecked(verse, bookMark),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool isChecked = snapshot.hasData && (snapshot.data ?? false);
          return isChecked ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank);
        },
      ),
    );
  }
}
