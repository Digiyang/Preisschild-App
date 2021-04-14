import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/settings_dao.dart';

class SettingsService {
  final DBConnector connector = DBConnector();
  StreamController<SettingsDao> settingsStream = StreamController();

  Future<void> create_settings(SettingsDao settings) async {
    var query = "INSERT INTO Preisschild.tbl_settings(locale, welcome_text) VALUES(" +
                "'" + settings.language + "', '" + settings.welcomeSpeech + "')";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

  Future<SettingsDao> get_settings_by_org_id(int organizationId) async {
    var query = "SELECT org_settings.* FROM Preisschild.tbl_settings org_settings, Preisschild.tbl_organization org WHERE org_settings.id = org.settings_id AND org.id = " + organizationId.toString();

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        settingsStream.close();
      }

      List<SettingsDao> details = SettingsDao.convert(v);

      if (details.length > 0) {
        for (SettingsDao sd in details) {
          settingsStream.add(sd);
        }
      }
    });

    List<SettingsDao> details = [];
    await for (SettingsDao sd in settingsStream.stream) {
      details.add(sd);
    }

    return Future.value(details.first);
  }

  Future<SettingsDao> get_settings_by_org_name(String orgName) async {
    var query = "SELECT org_settings.* FROM Preisschild.tbl_settings org_settings, Preisschild.tbl_organization org WHERE org_settings.id = org.settings_id AND org.name = '$orgName'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        settingsStream.close();
      }

      List<SettingsDao> details = SettingsDao.convert(v);

      if (details.length > 0) {
        for (SettingsDao sd in details) {
          settingsStream.add(sd);
        }
      }
    });

    List<SettingsDao> details = [];
    await for (SettingsDao sd in settingsStream.stream) {
      details.add(sd);
    }

    return Future.value(details.first);
  }
}