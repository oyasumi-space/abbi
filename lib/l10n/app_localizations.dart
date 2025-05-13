import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'ABII'**
  String get app_name;

  /// No description provided for @page_mods.
  ///
  /// In en, this message translates to:
  /// **'Mods'**
  String get page_mods;

  /// No description provided for @page_profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get page_profiles;

  /// No description provided for @page_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get page_settings;

  /// No description provided for @action_add_profiles.
  ///
  /// In en, this message translates to:
  /// **'Add New Profiles'**
  String get action_add_profiles;

  /// No description provided for @action_open_explorer.
  ///
  /// In en, this message translates to:
  /// **'Open in Explorer'**
  String get action_open_explorer;

  /// No description provided for @action_edit_profile_name.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Name'**
  String get action_edit_profile_name;

  /// No description provided for @settings_category_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settings_category_general;

  /// No description provided for @settings_title_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_title_language;

  /// No description provided for @settings_title_mods_path.
  ///
  /// In en, this message translates to:
  /// **'Mods Save Folder'**
  String get settings_title_mods_path;

  /// No description provided for @settings_title_profiles_path.
  ///
  /// In en, this message translates to:
  /// **'Profiles Save Folder'**
  String get settings_title_profiles_path;

  /// No description provided for @settings_title_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_title_dark_mode;

  /// No description provided for @settings_path_extra_desc.
  ///
  /// In en, this message translates to:
  /// **'The following strings will be replaced automatically.'**
  String get settings_path_extra_desc;

  /// No description provided for @settings_path_extra_desc_omori.
  ///
  /// In en, this message translates to:
  /// **'Game Folder'**
  String get settings_path_extra_desc_omori;

  /// No description provided for @settings_path_extra_desc_abii.
  ///
  /// In en, this message translates to:
  /// **'This App\'s Folder'**
  String get settings_path_extra_desc_abii;

  /// No description provided for @settings_path_open.
  ///
  /// In en, this message translates to:
  /// **'Open Folder'**
  String get settings_path_open;

  /// No description provided for @settings_input_empty.
  ///
  /// In en, this message translates to:
  /// **'Input Required.'**
  String get settings_input_empty;

  /// No description provided for @settings_input_contains_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Input contains unsupported characters.'**
  String get settings_input_contains_unsupported;

  /// No description provided for @settings_input_already_used.
  ///
  /// In en, this message translates to:
  /// **'Already used.'**
  String get settings_input_already_used;

  /// No description provided for @dialog_title_add_profiles.
  ///
  /// In en, this message translates to:
  /// **'Add Profiles'**
  String get dialog_title_add_profiles;

  /// No description provided for @omori_status_not_installed.
  ///
  /// In en, this message translates to:
  /// **'OMORI is not installed'**
  String get omori_status_not_installed;

  /// No description provided for @omori_status_updating.
  ///
  /// In en, this message translates to:
  /// **'OMORI is updating'**
  String get omori_status_updating;

  /// No description provided for @omori_status_running.
  ///
  /// In en, this message translates to:
  /// **'OMORI is already running'**
  String get omori_status_running;

  /// No description provided for @launch_omori.
  ///
  /// In en, this message translates to:
  /// **'Launch OMORI with Mods'**
  String get launch_omori;

  /// No description provided for @app_locked.
  ///
  /// In en, this message translates to:
  /// **'ABBI is locked'**
  String get app_locked;

  /// No description provided for @force_unlock.
  ///
  /// In en, this message translates to:
  /// **'Force Unlock'**
  String get force_unlock;

  /// No description provided for @app_locked_desc.
  ///
  /// In en, this message translates to:
  /// **'ABBI is locked because OMORI is running. \nWhen you close OMORI, it will be unlocked automatically. \nIf you force unlock while the game is running, the link to the MOD will be removed, \nwhich may cause problems such as corrupted save data. \nPlease proceed at your own risk.'**
  String get app_locked_desc;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @ee_omori.
  ///
  /// In en, this message translates to:
  /// **'OMORI🔪'**
  String get ee_omori;

  /// No description provided for @ee_sunny.
  ///
  /// In en, this message translates to:
  /// **'SUNNY☀'**
  String get ee_sunny;

  /// No description provided for @ee_aubrey.
  ///
  /// In en, this message translates to:
  /// **'AUBREY🍆'**
  String get ee_aubrey;

  /// No description provided for @ee_kel.
  ///
  /// In en, this message translates to:
  /// **'KEL🏀'**
  String get ee_kel;

  /// No description provided for @ee_hero.
  ///
  /// In en, this message translates to:
  /// **'HERO🍳'**
  String get ee_hero;

  /// No description provided for @ee_basil.
  ///
  /// In en, this message translates to:
  /// **'BASIL🌸'**
  String get ee_basil;

  /// No description provided for @ee_mari.
  ///
  /// In en, this message translates to:
  /// **'MARI🧺'**
  String get ee_mari;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
