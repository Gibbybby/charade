class AppState {
  static String languageCode = 'de'; // Standard: Deutsch

  static void setLanguageCode(String code) {
    languageCode = code;
  }

  static String getLanguageCode() {
    return languageCode;
  }
}
