import 'package:flutter/cupertino.dart';
import 'package:nations_bible/ui/features/searcher/searcher_controller.dart';
import 'package:nations_bible/ui/features/searcher/searcher_page.dart';

import '../../../domain/models/verse.dart';

class SearcherFeature extends StatelessWidget {
  final Function(Verse verse) onTapVerse;
  final SearcherController searcherController;
  const SearcherFeature({super.key, required this.onTapVerse, required this.searcherController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: searcherController,
      builder: (context, child) => SearcherPage(controller: searcherController, onTapVerse: onTapVerse),
    );
  }
}
