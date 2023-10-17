import 'package:flutter/material.dart';

class ChapterNavigationListTile extends StatelessWidget {
  final Function() onTapPrevious;
  final Function() onTapNext;
  const ChapterNavigationListTile({
    super.key,
    required this.onTapPrevious,
    required this.onTapNext,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onTapPrevious,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: onTapNext,
      ),
    );
  }
}
