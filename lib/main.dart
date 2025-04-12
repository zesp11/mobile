import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotale/app/bindings/app_binding.dart';
import 'package:gotale/app/controllers/settings_controller.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/location_service.dart';
import 'package:gotale/app/services/lobby_service.dart';
import 'package:gotale/app/services/settings_service.dart';
import 'package:gotale/app/themes/app_theme.dart';
import 'package:gotale/utils/env_config.dart';
import 'package:gotale/utils/translations.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/services/api_service/productionApiService.dart';
import 'package:gotale/app/services/auth_service.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:gotale/app/services/home_service.dart';
import 'package:gotale/app/services/search_service.dart';
import 'package:gotale/app/services/user_service.dart';

// top-level constant for production flag
// TODO: maybe move that comments to README.md file
// For production, run with dart --define=dart.vm.product=true.
// For development, no additional flags are needed (default is false).
const bool isProduction = bool.fromEnvironment('dart.vm.product');

void initServices() async {
  final logger = Get.find<Logger>();
  logger.i("Starting services");

  _registerApiService(logger);
  // Register services using the injected ApiService
  Get.put(UserService(apiService: Get.find()));
  Get.put(SearchService(apiService: Get.find()));
  Get.put(HomeService(apiService: Get.find()));
  Get.put(GameService(apiService: Get.find()));
  Get.put(AuthService(apiService: Get.find()));
  Get.put(LobbyService(apiService: Get.find()));
  Get.put(FlutterSecureStorage());
  Get.put(SettingsService());
  Get.put(LocationService());

  logger.i("All services started");
}

void _registerApiService(Logger logger) {
  if (EnvConfig.isProduction || EnvConfig.isDebugProd) {
    logger.d("Registering production API service");
    Get.lazyPut<ApiService>(() => ProductionApiService());
  } else {
    logger.d("Registering development API service.");
    logger.e("Unimplemented");
    UnimplementedError("Development server is not implemented");
    // Get.lazyPut<ApiService>(
    //     () => DevelopmentApiService(delay: Duration(seconds: 2)));
  }
}

Logger _createLogger(bool isProduction) {
  return Logger(
    level: isProduction ? Level.warning : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 80,
      printEmojis: false,
      colors: !isProduction,
      noBoxingByDefault: true, // Remove border boxes
      dateTimeFormat: isProduction
          ? DateTimeFormat.onlyTime // "HH:mm:ss" format
          : DateTimeFormat.none,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put<Logger>(_createLogger(isProduction));

  initServices();
  // Load translations before app start
  final settingsService = Get.find<SettingsService>();
  final messages = await Messages.loadTranslations();

  // Check first launch
  bool firstLaunch = settingsService.isFirstLaunch();
  if (firstLaunch) {
    await settingsService.setFirstLaunch(false);
  }

  // Register controllers
  Get.put<SettingsController>(
      SettingsController(settingService: settingsService));

  runApp(GoTale(
    firstLaunch: firstLaunch,
    messages: messages,
  ));
}

class GoTale extends StatelessWidget {
  final bool firstLaunch;
  final Messages messages;
  final settings = Get.find<SettingsController>();

  GoTale({
    super.key,
    required this.firstLaunch,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'GoTale',
        // initialRoute: firstLaunch ? '/welcome' : '/',
        initialRoute: true ? '/welcome' : '/',
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
