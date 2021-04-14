class SettingsDao {
  int id;
  String locale;
  String welcomeText;

  SettingsDao(int id, String locale,
              String welcomeText) {

    this.id = id;
    this.locale = locale;
    this.welcomeText = welcomeText;
  }

  String get language {
    return locale;
  }

  String get welcomeSpeech {
    return welcomeText;
  }

  static List<SettingsDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<SettingsDao> settings_details = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("id")) {
          continue;
        }

        List<String> values = l.split("|");
        settings_details.add(SettingsDao(int.parse(values[1].trim()),
                              values[2].trim(), values[3].trim()));
      }
    }

    return settings_details;
  }
}