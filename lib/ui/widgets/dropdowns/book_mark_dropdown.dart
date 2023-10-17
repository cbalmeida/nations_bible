import 'package:flutter/material.dart';

import '../../../domain/models/book_mark.dart';

class BookMarkDropDown extends StatelessWidget {
  final BookMark? selectedBookMark;
  final List<BookMark> bookMarks;
  final Future<bool> Function(BookMark?) onChanged;
  const BookMarkDropDown({
    super.key,
    required this.selectedBookMark,
    required this.bookMarks,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<BookMark?>(
      alignment: AlignmentDirectional.centerEnd,
      isExpanded: true,
      value: selectedBookMark,
      onChanged: onChanged,
      items: bookMarks
          .map<DropdownMenuItem<BookMark>>((BookMark bookMark) => DropdownMenuItem<BookMark>(
                value: bookMark,
                child: Row(
                  children: [
                    Icon(Icons.bookmark, color: bookMark.color),
                    Text(bookMark.title),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
