import 'package:flutter/material.dart';

import '../../../domain/models/book_mark.dart';
import '../../widgets/dropdowns/color_dropdown.dart';
import 'marker_controller.dart';

class MarkerEditPage extends StatelessWidget {
  final MarkerController controller;
  const MarkerEditPage({super.key, required this.controller});

  static void showPage(BuildContext context, MarkerController controller) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MarkerEditPage(controller: controller)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Edit BookMark")),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 6, child: TextField(controller: controller.titleEditController, decoration: const InputDecoration(hintText: "Title", border: UnderlineInputBorder()))),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: ColorDropDown(selectedColor: controller.selectedBookMark?.color, colors: BookMark.colors, onChanged: controller.setSelectedBookMarkColor)),
              ],
            ),
            TextField(controller: controller.descriptionEditController, decoration: const InputDecoration(hintText: "Description", border: UnderlineInputBorder())),
          ],
        ));
  }
}
