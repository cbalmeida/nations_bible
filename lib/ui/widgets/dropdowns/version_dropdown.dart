import 'package:flutter/material.dart';

import '../../../domain/models/version.dart';

class VersionDropDown extends StatelessWidget {
  final Version? selectedVersion;
  final List<Version> versions;
  final Function(Version?) onChanged;
  const VersionDropDown({
    super.key,
    required this.selectedVersion,
    required this.versions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Version?>(
      alignment: AlignmentDirectional.centerEnd,
      isExpanded: true,
      value: selectedVersion,
      onChanged: onChanged,
      items: versions
          .map<DropdownMenuItem<Version>>(
            (Version version) => DropdownMenuItem<Version>(
              value: version,
              child: Center(child: Text("${version.versionShortName} [${version.language.languageShortName}]", style: TextStyle(fontSize: 14, fontWeight: version == selectedVersion ? FontWeight.bold : null))),
            ),
          )
          .toList(),
    );
  }
}
