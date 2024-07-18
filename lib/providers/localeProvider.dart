import 'package:flutter_application_1/providers/sharePrefsProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<bool> {
  LocaleNotifier() : super(false);
  void toggleLocaleStatus() {
    if (state == true) {
      state = false;
    } else {
      state = true;
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, bool>((ref) {
  return LocaleNotifier();
});
