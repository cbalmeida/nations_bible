import 'package:flutter/cupertino.dart';
import 'package:nations_bible/ui/features/reader/reader_controller.dart';
import 'package:nations_bible/ui/features/reader/reader_page.dart';

import '../../../domain/models/verse.dart';
import '../marker/marker_controller.dart';

class ReaderFeature extends StatelessWidget {
  final ReaderController readerController;
  final MarkerController markerController;
  final Function(Verse verse) onTapVerse;
  const ReaderFeature({
    super.key,
    required this.readerController,
    required this.markerController,
    required this.onTapVerse,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: markerController,
      builder: (context, child) => AnimatedBuilder(
        animation: readerController,
        builder: (context, child) => ReaderPage(readerController: readerController, markerController: markerController, onTapVerse: onTapVerse),
      ),
    );
  }
}
