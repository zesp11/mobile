import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goadventure/app/bindings/app_binding.dart';
import 'package:goadventure/app/controllers/settings_controller.dart';
import 'package:goadventure/app/routes/app_routes.dart';
import 'package:goadventure/utils/translations.dart';

// top-level constant for production flag
// TODO: maybe move that comments to README.md file
// For production, run with dart --define=dart.vm.product=true.
// For development, no additional flags are needed (default is false).
const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() async {
  await GetStorage.init();

  runApp(const GoAdventure());
}

class GoAdventure extends StatelessWidget {
  const GoAdventure({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gamebook App',
      initialRoute: '/',
      translations: Messages(),
      initialBinding: AppBindings(),
      getPages: AppRoutes.routes,
      locale: null,
      fallbackLocale: Locale('en'),
      debugShowCheckedModeBanner: !isProduction,
    );
  }
}
