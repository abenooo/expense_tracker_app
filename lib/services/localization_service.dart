import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/languages.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  late SharedPreferences _prefs;
  late Locale _currentLocale;

  Locale get currentLocale => _currentLocale;

  static final List<Locale> supportedLocales = LanguageConfig.languages.values
      .map((lang) => Locale(lang.code, ''))
      .toList();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final storedLanguageCode = _prefs.getString(_languageKey);
    if (storedLanguageCode != null) {
      _currentLocale = Locale(storedLanguageCode, '');
    } else {
      _currentLocale = Locale(LanguageConfig.languages[Language.english]!.code, '');
    }
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
    _currentLocale = Locale(languageCode, '');
    notifyListeners();
  }

  String translate(String key) {
    final translations = _getTranslations(_currentLocale.languageCode);
    return translations[key] ?? key;
  }

  Map<String, String> _getTranslations(String languageCode) {
    switch (languageCode) {
      case 'am':
        return _amharicTranslations;
      case 'om':
        return _oromiffaTranslations;
      case 'ti':
        return _tigrinyaTranslations;
      case 'so':
        return _somaliTranslations;
      case 'aa':
        return _afarTranslations;
      default:
        return _englishTranslations;
    }
  }

  final Map<String, String> _englishTranslations = {
    'Ethiopian Bank Tracker': 'Ethiopian Bank Tracker',
    'No financial accounts found': 'No financial accounts found',
    'SMS permission is required': 'SMS permission is required',
    'Grant Permission': 'Grant Permission',
    'Available Balance': 'Available Balance',
    'Recent Transactions': 'Recent Transactions',
    'Change Language': 'Change Language',
    'Transactions': 'Transactions',
    'No transactions found': 'No transactions found',
    'No recent transactions': 'No recent transactions',
    'Choose Your Language': 'Choose Your Language',
  };

  final Map<String, String> _amharicTranslations = {
    'Ethiopian Bank Tracker': 'የኢትዮጵያ ባንክ መከታተያ',
    'No financial accounts found': 'ምንም የፋይናንስ ሂሳብ አልተገኘም',
    'SMS permission is required': 'የኤስኤምኤስ ፍቃድ ያስፈልጋል',
    'Grant Permission': 'ፍቃድ ስጥ',
    'Available Balance': 'ያለ ሂሳብ',
    'Recent Transactions': 'የቅርብ ጊዜ ግብይቶች',
    'Change Language': 'ቋንቋ ለውጥ',
    'Transactions': 'ግብይቶች',
    'No transactions found': 'ምንም ግብይት አልተገኘም',
    'No recent transactions': 'የቅርብ ጊዜ ግብይቶች የሉም',
    'Choose Your Language': 'ቋንቋዎን ይምረጡ',
  };

  final Map<String, String> _oromiffaTranslations = {
    'Ethiopian Bank Tracker': 'Hordoffii Baankii Itoophiyaa',
    'No financial accounts found': 'Herrega maallaqaa hin argamne',
    'SMS permission is required': 'Hayyama SMS barbaachisaadha',
    'Grant Permission': 'Hayyama kenni',
    'Available Balance': 'Balansi jiru',
    'Recent Transactions': 'Daddabarsa dhiyoo',
    'Change Language': 'Afaan jijjiiri',
    'Transactions': 'Daddabarsa',
    'No transactions found': 'Daddabarsi hin argamne',
    'No recent transactions': 'Daddabarsi dhiyoo hin jiru',
    'Choose Your Language': 'Afaan kee filadhu',
  };

  final Map<String, String> _tigrinyaTranslations = {
    'Ethiopian Bank Tracker': 'ኢትዮጵያ ባንኪ መከታተሊ',
    'No financial accounts found': 'ዝኾነ ፋይናንሳዊ ሒሳብ ኣይተረኽበን',
    'SMS permission is required': 'ፍቓድ ኤስኤምኤስ የድሊ',
    'Grant Permission': 'ፍቓድ ሃብ',
    'Available Balance': 'ዘሎ ባላንስ',
    'Recent Transactions': 'ናይ ቀרב እዋን ንግዳዊ ልውውጥ',
    'Change Language': 'ቋንቋ ቀይር',
    'Transactions': 'ንግዳዊ ልውውጥ',
    'No transactions found': 'ዝኾነ ንግዳዊ ልውውጥ ኣይተረኽበን',
    'No recent transactions': 'ናይ ቀרב እዋን ንግዳዊ ልውውጥ የለን',
    'Choose Your Language': 'ቋንቋኻ ምረጽ',
  };

  final Map<String, String> _somaliTranslations = {
    'Ethiopian Bank Tracker': 'Raadiyaha Bangiga Itoobiya',
    'No financial accounts found': 'Lama helin xisaabta maaliyadeed',
    'SMS permission is required': 'Ogolaanshaha SMS ayaa loo baahan yahay',
    'Grant Permission': 'Ogolaansho sii',
    'Available Balance': 'Haraaga la heli karo',
    'Recent Transactions': 'Dhaqdhaqaaqyada dhowaan',
    'Change Language': 'Luqadda beddel',
    'Transactions': 'Dhaqdhaqaaqyada',
    'No transactions found': 'Lama helin wax dhaqdhaqaaq ah',
    'No recent transactions': 'Ma jiraan dhaqdhaqaaqyo dhowaan ah',
    'Choose Your Language': 'Dooro luqaddaada',
  };

  final Map<String, String> _afarTranslations = {
    'Ethiopian Bank Tracker': 'Yetiyobiya Bankii Feetha',
    'No financial accounts found': 'Lakkoofsa maallaqaa hin argamne',
    'SMS permission is required': 'Eeyyama SMS barbaachisaadha',
    'Grant Permission': 'Eeyyama kenni',
    'Available Balance': 'Madaallii jiru',
    'Recent Transactions': 'Gurgurtaa dhiyoo',
    'Change Language': 'Afaan jijjiiri',
    'Transactions': 'Gurgurtaa',
    'No transactions found': 'Gurgurtaan hin argamne',
    'No recent transactions': 'Gurgurtaan dhiyoo hin jiru',
    'Choose Your Language': 'Afaan kee filadhu',
  };
}

