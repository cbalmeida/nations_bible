import 'package:nations_bible/domain/models/language.dart';

class Version {
  final String versionLongName;
  final String versionShortName;
  final Language language;
  final String fileName;

  Version({
    required this.versionLongName,
    required this.versionShortName,
    required this.language,
    required this.fileName,
  });

  static List<Version> get versions => [
        almeida_ra,
        almeida_rc,
        blivre,
        asv,
        web,
        kjv,
      ];

  // region Portuguese

  static final Version almeida_ra = Version(versionLongName: 'Almeida Revista e Atualizada', versionShortName: 'JFA-RA', language: LanguagePortuguese(), fileName: 'almeida_ra.sqlite');

  static final Version almeida_rc = Version(versionLongName: 'Almeida Revista e Corrigida', versionShortName: 'JFA-RC', language: LanguagePortuguese(), fileName: 'almeida_rc.sqlite');

  static final Version blivre = Version(versionLongName: 'Biblia Livre', versionShortName: 'BLIVRE', language: LanguagePortuguese(), fileName: 'blivre.sqlite');

  // endregion

  // region English

  static final Version asv = Version(versionLongName: 'American Standard Version', versionShortName: 'ASV', language: LanguageEnglish(), fileName: 'asv.sqlite');

  static final Version web = Version(versionLongName: 'World English Bible', versionShortName: 'WEB', language: LanguageEnglish(), fileName: 'web.sqlite');

  static final Version kjv = Version(versionLongName: 'Authorized King James Version', versionShortName: 'KJV', language: LanguageEnglish(), fileName: 'kjv.sqlite');

// endregion
}
