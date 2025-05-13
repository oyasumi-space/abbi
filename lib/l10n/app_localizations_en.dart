// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get app_name => 'ABII';

  @override
  String get page_mods => 'Mods';

  @override
  String get page_profiles => 'Profiles';

  @override
  String get page_settings => 'Settings';

  @override
  String get action_add_profiles => 'Add New Profiles';

  @override
  String get action_open_explorer => 'Open in Explorer';

  @override
  String get action_edit_profile_name => 'Edit Profile Name';

  @override
  String get settings_category_general => 'General';

  @override
  String get settings_title_language => 'Language';

  @override
  String get settings_title_mods_path => 'Mods Save Folder';

  @override
  String get settings_title_profiles_path => 'Profiles Save Folder';

  @override
  String get settings_title_dark_mode => 'Dark Mode';

  @override
  String get settings_path_extra_desc => 'The following strings will be replaced automatically.';

  @override
  String get settings_path_extra_desc_omori => 'Game Folder';

  @override
  String get settings_path_extra_desc_abii => 'This App\'s Folder';

  @override
  String get settings_path_open => 'Open Folder';

  @override
  String get settings_input_empty => 'Input Required.';

  @override
  String get settings_input_contains_unsupported => 'Input contains unsupported characters.';

  @override
  String get settings_input_already_used => 'Already used.';

  @override
  String get dialog_title_add_profiles => 'Add Profiles';

  @override
  String get omori_status_not_installed => 'OMORI is not installed';

  @override
  String get omori_status_updating => 'OMORI is updating';

  @override
  String get omori_status_running => 'OMORI is already running';

  @override
  String get launch_omori => 'Launch OMORI with Mods';

  @override
  String get app_locked => 'ABBI is locked';

  @override
  String get force_unlock => 'Force Unlock';

  @override
  String get app_locked_desc => 'ABBI is locked because OMORI is running. \nWhen you close OMORI, it will be unlocked automatically. \nIf you force unlock while the game is running, the link to the MOD will be removed, \nwhich may cause problems such as corrupted save data. \nPlease proceed at your own risk.';

  @override
  String get loading => 'Loading...';

  @override
  String get ee_omori => 'OMORI🔪';

  @override
  String get ee_sunny => 'SUNNY☀';

  @override
  String get ee_aubrey => 'AUBREY🍆';

  @override
  String get ee_kel => 'KEL🏀';

  @override
  String get ee_hero => 'HERO🍳';

  @override
  String get ee_basil => 'BASIL🌸';

  @override
  String get ee_mari => 'MARI🧺';
}
