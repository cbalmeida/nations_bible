import 'package:flutter/material.dart';

import '../../../domain/models/book.dart';

class BookDropDown extends StatelessWidget {
  final Book? selectedBook;
  final List<Book> books;
  final Function(Book?) onChanged;
  const BookDropDown({
    super.key,
    required this.selectedBook,
    required this.books,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Book?>(
      alignment: AlignmentDirectional.centerEnd,
      isExpanded: true,
      value: selectedBook,
      onChanged: onChanged,
      items: books
          .map<DropdownMenuItem<Book>>(
            (Book book) => DropdownMenuItem<Book>(
              value: book,
              child: Center(child: Text(book.languageBookInfo.languageBookName, style: TextStyle(fontSize: 14, fontWeight: book == selectedBook ? FontWeight.bold : null))),
            ),
          )
          .toList(),
    );
  }
}
