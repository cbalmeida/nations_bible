import 'package:flutter/cupertino.dart';

import '../../../domain/models/verse.dart';
import 'marker_controller.dart';
import 'marker_page.dart';

class MarkerFeature extends StatelessWidget {
  final Function(Verse verse) onTapVerse;
  final MarkerController markerController;
  const MarkerFeature({super.key, required this.onTapVerse, required this.markerController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: markerController,
      builder: (context, child) => MarkerPage(controller: markerController, onTapVerse: onTapVerse),
    );
  }
}
