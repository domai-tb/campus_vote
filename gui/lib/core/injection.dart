import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_service.dart';
import 'package:campus_vote/header/header_service.dart';
import 'package:campus_vote/settings/settings_controller.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initServices() async {
  // Settings
  serviceLocator.registerSingletonAsync(
    () async => SettingsController(
      packageInfo: await PackageInfo.fromPlatform(),
      prefs: await SharedPreferences.getInstance(),
    ),
  );

  // Crypto
  serviceLocator.registerLazySingleton(
    () => Crypto(storage: serviceLocator<FlutterSecureStorage>()),
  );

  // State
  serviceLocator.registerLazySingleton(
    () => CampusVoteState(
      storage: serviceLocator<FlutterSecureStorage>(),
      setupServices: serviceLocator<SetupServices>(),
      headerServices: serviceLocator<HeaderServices>(),
      stateServices: serviceLocator<CampusVoteStateServices>(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => CampusVoteStateServices(
      headerServices: serviceLocator<HeaderServices>(),
      setupServices: serviceLocator<SetupServices>(),
    ),
  );

  // Setup
  serviceLocator.registerLazySingleton(SetupServices.new);

  // Header
  serviceLocator.registerLazySingleton(HeaderServices.new);

  // External
  serviceLocator.registerLazySingleton(FlutterSecureStorage.new);

  await serviceLocator.allReady();
}
