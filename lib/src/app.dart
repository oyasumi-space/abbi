import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'pod/config_pod.dart';
import 'window/home_window.dart';

class App extends ConsumerWidget {
  const App({super.key});

  static const _spaceParalaxColor = Color.fromARGB(255, 108, 14, 255);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languagePod);
    return MaterialApp(
      home: HomeWidndow(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(language, ''),
      theme: ThemeData.light().copyWith(primaryColor: _spaceParalaxColor),
      darkTheme: ThemeData.dark().copyWith(primaryColor: _spaceParalaxColor),
      themeMode: ref.watch(isDarkThemePod) ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
