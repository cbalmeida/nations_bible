import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CustomListView extends StatefulWidget {
  final ItemScrollController itemScrollController;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  const CustomListView({
    super.key,
    required this.itemScrollController,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int firstVisibleItem = 0;

  Timer? _timerEndScroll;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onItemScroll);
  }

  @override
  void dispose() {
    super.dispose();
    itemPositionsListener.itemPositions.removeListener(_onItemScroll);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemScrollController: widget.itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  _onItemScroll() {
    final itemPositions = itemPositionsListener.itemPositions.value;
    final visibleItems = itemPositions.where((ItemPosition itemPosition) => itemPosition.itemTrailingEdge > 0 && itemPosition.itemLeadingEdge < 1).toList();
    final firstVisibleItem = visibleItems.isNotEmpty ? visibleItems.first.index : 0;

    if (_timerEndScroll != null) _timerEndScroll!.cancel();
    _timerEndScroll = Timer(const Duration(milliseconds: 100), () => _onEndScroll(firstVisibleItem));

    if (firstVisibleItem != this.firstVisibleItem) {
      setState(() {
        this.firstVisibleItem = firstVisibleItem;
        HapticFeedback.selectionClick();
        // print("firstVisibleItem: $firstVisibleItem");
      });
    }
  }

  _onEndScroll(int firstVisibleItem) {
    // widget.itemScrollController.scrollTo(index: firstVisibleItem, duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
  }
}
