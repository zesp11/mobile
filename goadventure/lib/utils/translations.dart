import 'package:get/get.dart';
import 'package:goadventure/utils/eng.dart';
import 'package:goadventure/utils/pl.dart';

// TODO: those files should be inside json
class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': eng_translations,
        'pl': pl_translations,
      };
}
