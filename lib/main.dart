import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

Future<void> main() async {
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
