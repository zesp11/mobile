import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goadventure/app/bindings/app_binding.dart';
import 'package:goadventure/app/controllers/settings_controller.dart';
import 'package:goadventure/app/routes/app_routes.dart';
import 'package:goadventure/app/services/settings_service.dart';
import 'package:goadventure/app/themes/app_theme.dart';
import 'package:goadventure/utils/translations.dart';
import 'package:logger/logger.dart';

// top-level constant for production flag
// TODO: maybe move that comments to README.md file
// For production, run with dart --define=dart.vm.product=true.
// For development, no additional flags are needed (default is false).
const bool isProduction = bool.fromEnvironment('dart.vm.product');

Logger _createLogger(bool isProduction) {
  return Logger(
    level: isProduction ? Level.warning : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      lineLength: 80,
      printEmojis: !isProduction,
      colors: !isProduction, // Disable colors in production
      dateTimeFormat: isProduction // Show timestamps in production
          ? DateTimeFormat.onlyTimeAndSinceStart
          : DateTimeFormat.none,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize logger
  Logger logger = _createLogger(isProduction);
  Get.put<Logger>(logger);

  // Load translations before app start
  final messages = await Messages.loadTranslations();

  // Initialize settings
  await Get.putAsync<SettingsService>(() async => SettingsService());
  final settingsService = Get.find<SettingsService>();

  // Check first launch
  bool firstLaunch = settingsService.isFirstLaunch();
  if (firstLaunch) {
    await settingsService.setFirstLaunch(false);
  }

  // Register controllers
  Get.put<SettingsController>(
      SettingsController(settingService: settingsService));

  runApp(GoAdventure(
    firstLaunch: firstLaunch,
    messages: messages,
  ));
}

class GoAdventure extends StatelessWidget {
  final bool firstLaunch;
  final Messages messages;
  final settings = Get.find<SettingsController>();

  GoAdventure({
    super.key,
    required this.firstLaunch,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Gamebook App',
        initialRoute: firstLaunch ? '/welcome' : '/',
        translations: messages,
        locale: Locale(settings.language.value),
        fallbackLocale: const Locale('en'),
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: settings.themeMode.value,
        initialBinding: AppBindings(),
        getPages: AppRoutes.routes,
        debugShowCheckedModeBanner: !isProduction,
      ),
    );
  }
}
