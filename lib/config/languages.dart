enum Language { english, amharic, oromiffa, tigrinya, somali, afar }

class LanguageConfig {
  final String name;
  final String nativeName;
  final String code;

  const LanguageConfig({
    required this.name,
    required this.nativeName,
    required this.code,
  });

  static const Map<Language, LanguageConfig> languages = {
    Language.english: LanguageConfig(
      name: 'English',
      nativeName: 'English',
      code: 'en',
    ),
    Language.amharic: LanguageConfig(
      name: 'Amharic',
      nativeName: 'አማርኛ',
      code: 'am',
    ),
    Language.oromiffa: LanguageConfig(
      name: 'Oromiffa',
      nativeName: 'Oromoo',
      code: 'om',
    ),
    Language.tigrinya: LanguageConfig(
      name: 'Tigrinya',
      nativeName: 'ትግርኛ',
      code: 'ti',
    ),
    Language.somali: LanguageConfig(
      name: 'Somali',
      nativeName: 'Soomaali',
      code: 'so',
    ),
    Language.afar: LanguageConfig(
      name: 'Afar',
      nativeName: 'Qafar',
      code: 'aa',
    ),
  };
}

