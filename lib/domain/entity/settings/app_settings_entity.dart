// domain/entities/app_settings_entity.dart

class AppSettingsEntity {
  final bool darkMode;
  final String language;
  final String distanceUnit;
  final bool notificationsEnabled;
  final bool locationEnabled;

  AppSettingsEntity({
    this.darkMode = false,
    this.language = 'pt_BR',
    this.distanceUnit = 'km',
    this.notificationsEnabled = true,
    this.locationEnabled = true,
  });

  AppSettingsEntity copyWith({
    bool? darkMode,
    String? language,
    String? distanceUnit,
    bool? notificationsEnabled,
    bool? locationEnabled,
  }) {
    return AppSettingsEntity(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
    );
  }
}
