import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final String highlightText;

  const HighlightText({
    super.key,
    required this.text,
    required this.style,
    required this.highlightText,
  });

  @override
  Widget build(BuildContext context) {
    if ((highlightText.isEmpty) || text.isEmpty) return Text(text, style: style);

    var sourceText = text.toLowerCase();
    var targetHighlight = highlightText.toLowerCase();

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;
    do {
      indexOfHighlight = sourceText.indexOf(targetHighlight, start);
      if (indexOfHighlight < 0) {
        spans.add(_normalSpan(text.substring(start)));
        break;
      }
      if (indexOfHighlight > start) {
        spans.add(_normalSpan(text.substring(start, indexOfHighlight)));
      }
      start = indexOfHighlight + highlightText.length;
      spans.add(_highlightSpan(text.substring(indexOfHighlight, start)));
    } while (true);

    return Text.rich(TextSpan(children: spans));
  }

  TextSpan _highlightSpan(String content) {
    return TextSpan(text: content, style: style.copyWith(color: Colors.black, backgroundColor: Colors.yellow));
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content, style: style);
  }
}
