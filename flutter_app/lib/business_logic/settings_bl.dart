import 'package:flutter_app/Services/settings_service.dart';
import 'package:flutter_app/data_access/settings_dao.dart';

class SettingsBL {
  final SettingsService service = SettingsService();

  //TODO try to make generic bl functions
  Future<int> create_settings(int organizationId, SettingsDao settings) async {
    int settingsId = await service.create_settings(organizationId, settings);
    return Future.value(settingsId);
  }

  Future<void> update_settings(SettingsDao settings) async {
    await service.update_settings(settings);
  }

  Future<SettingsDao> get_settings_by_org_id(int organizationId) async {
    SettingsDao detail = await service.get_settings_by_org_id(organizationId);
    return Future.value(detail);
  }

  Future<SettingsDao> get_settings_by_org_name(String name) async {
    SettingsDao detail = await service.get_settings_by_org_name(name);
    return Future.value(detail);
  }
}