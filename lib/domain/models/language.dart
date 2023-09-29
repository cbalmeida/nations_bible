class Version {
  final String versionName;
  final String languageName;
  final String fileName;

  Version({
    required this.versionName,
    required this.languageName,
    required this.fileName,
  });

  static Version almeida_ra() {
    return Version(
      versionName: 'JFA-RA',
      languageName: 'Português',
      fileName: 'almeida_ra.sqlite',
    );
  }
}
