import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/settings/settings_controller.dart';
import 'package:campus_vote/themes/theme_dark.dart';
import 'package:campus_vote/themes/theme_light.dart';
import 'package:campus_vote/widgets/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() async {
  // ensure initialisation
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  runApp(CampusVote());
}

class CampusVote extends StatelessWidget {
  final settingsController = serviceLocator<SettingsController>();

  CampusVote({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'campus_vote',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
          ],
          locale: settingsController.language,
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsController.themeMode,
          home: MainView(),
        );
      },
    );
  }
}
