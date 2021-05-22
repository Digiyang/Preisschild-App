import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/settings_dao.dart';
import 'package:mysql1/mysql1.dart';

class SettingsService {
  final DBConnector connector = DBConnector();
  StreamController<SettingsDao> settingsStream = StreamController();

  Future<int> create_settings(int organizationId, SettingsDao settings) async {
    // var query = "INSERT INTO Preisschild.tbl_settings(locale, welcome_text) VALUES(" +
    //             "'" + settings.language + "', '" + settings.welcomeSpeech + "')";
    // var result = await conn.query(query);
    // var exitcode = await connector.execute_through_ssh(query, (_ , v) {});

    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    var query = "CALL create_organization_settings(?, ?, ?)";
    var  result = await conn.query(query, [organizationId, settings.language, settings.welcomeSpeech]);

    int settingsId = 0;
    if (result.isNotEmpty) {
      ResultRow r = result.first;
      settingsId = r.fields["inserted_row_id"];
    }

    // Finally, close the connection
    await conn.close();

    return Future.value(settingsId);
  }

  Future<void> update_settings(SettingsDao settings) async {
    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    var query = "UPDATE Preisschild.tbl_settings s SET s.locale = ?, s.welcome_text = ? WHERE s.id = ?";
    await conn.query(query, [settings.language, settings.welcomeSpeech, settings.iD]);

    // Finally, close the connection
    await conn.close();
  }

  Future<SettingsDao> get_settings_by_org_id(int organizationId) async {
    // var query = "SELECT org_settings.* FROM Preisschild.tbl_settings org_settings, Preisschild.tbl_organization org WHERE org_settings.id = org.settings_id AND org.id = " + organizationId.toString();
    //
    // var exitcode = await connector.execute_through_ssh(query, (_ , v) {
    //   if (v.trim() == "logout") {
    //     settingsStream.close();
    //   }
    //
    //   List<SettingsDao> details = SettingsDao.convert(v);
    //
    //   if (details.length > 0) {
    //     for (SettingsDao sd in details) {
    //       settingsStream.add(sd);
    //     }
    //   }
    // });
    //
    // List<SettingsDao> details = [];
    // await for (SettingsDao sd in settingsStream.stream) {
    //   details.add(sd);
    // }
    //
    // return Future.value(details.first);

    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    var query = "SELECT org_settings.* FROM Preisschild.tbl_settings org_settings, Preisschild.tbl_organization org WHERE org_settings.id = org.settings_id AND org.id = ?";
    var result = await conn.query(query, [organizationId]);

    SettingsDao settings;
    if (result.isNotEmpty) {
        ResultRow r = result.first;
        settings = SettingsDao(r.fields["id"], r.fields["locale"], r.fields["welcome_text"]);
    }

    // Finally, close the connection
    await conn.close();

    return Future.value(settings);
  }

  Future<SettingsDao> get_settings_by_org_name(String orgName) async {
    // var query = "SELECT org_settings.* FROM Preisschild.tbl_settings org_settings, Preisschild.tbl_organization org WHERE org_settings.id = org.settings_id AND org.name = '$orgName'";
    //
    // var exitcode = await connector.execute_through_ssh(query, (_ , v) {
    //   if (v.trim() == "logout") {
    //     settingsStream.close();
    //   }
    //
    //   List<SettingsDao> details = SettingsDao.convert(v);
    //
    //   if (details.length > 0) {
    //     for (SettingsDao sd in details) {
    //       settingsStream.add(sd);
    //     }
    //   }
    // });
    //
    // List<SettingsDao> details = [];
    // await for (SettingsDao sd in settingsStream.stream) {
    //   details.add(sd);
    // }
    //
    // return Future.value(details.first);

    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    var query = "SELECT org_settings.* FROM Preisschild.tbl_settings org_settings, Preisschild.tbl_organization org WHERE org_settings.id = org.settings_id AND org.name = ?";
    var result = await conn.query(query, [orgName]);

    SettingsDao settings;
    if (result.isNotEmpty) {
      ResultRow r = result.first;
      settings = SettingsDao(r.fields["id"], r.fields["locale"], r.fields["welcome_text"]);
    }

    // Finally, close the connection
    await conn.close();

    return Future.value(settings);
  }
}