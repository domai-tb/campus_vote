import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  final SettingsController _settingsController =
      serviceLocator<SettingsController>();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: ListView(
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: _settingsController.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: _settingsController.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
            DropdownButton<Locale>(
              // Read the selected themeMode from the controller
              value: _settingsController.language,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: _settingsController.updateLanguage,
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(AppLocalizations.of(context)!.languageEn),
                ),
                DropdownMenuItem(
                  value: const Locale('de'),
                  child: Text(AppLocalizations.of(context)!.languageDe),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Campus Vote Version: ${_settingsController.packageInfo.version}',
            ),
          ],
        ),
      ),
    );
  }
}
