// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get language => '日本語';

  @override
  String get app_name => 'ABII';

  @override
  String get page_mods => 'MOD';

  @override
  String get page_profiles => 'プロファイル';

  @override
  String get page_settings => '設定';

  @override
  String get action_add_profiles => '新しいプロファイルを追加';

  @override
  String get action_open_explorer => 'エクスプローラーで開く';

  @override
  String get action_edit_profile_name => 'プロファイル名の編集';

  @override
  String get settings_category_general => '一般';

  @override
  String get settings_title_language => '言語';

  @override
  String get settings_title_mods_path => 'MODの保存フォルダ';

  @override
  String get settings_title_profiles_path => 'プロファイルの保存フォルダ';

  @override
  String get settings_title_dark_mode => 'ダークモード';

  @override
  String get settings_path_extra_desc => '以下の文字列は自動的に置き換えられます。';

  @override
  String get settings_path_extra_desc_omori => 'ゲームのフォルダ';

  @override
  String get settings_path_extra_desc_abii => 'このアプリのフォルダ';

  @override
  String get settings_path_open => 'フォルダを開く';

  @override
  String get settings_input_empty => '入力必須です。';

  @override
  String get settings_input_contains_unsupported => '使用できない文字が含まれています。';

  @override
  String get settings_input_already_used => '既に使用されています。';

  @override
  String get dialog_title_add_profiles => 'プロファイルを追加';

  @override
  String get omori_status_not_installed => 'OMORIがインストールされていません';

  @override
  String get omori_status_updating => 'OMORIはアップデート中です';

  @override
  String get omori_status_running => 'OMORIは現在起動中です';

  @override
  String get launch_omori => 'MOD付きでOMORIを起動';

  @override
  String get app_locked => 'ABBIはロック中';

  @override
  String get force_unlock => '強制アンロック';

  @override
  String get app_locked_desc => 'OMORIを起動中なのでABBIはロックされています。\nOMORIを終了すると、自動でロックは解除されます。\nゲームの起動中に強制アンロックすると、MODのリンクが解除されるため、\nセーブデータ破損などの不具合が起こる可能性があります。\n自己責任で行ってください。';

  @override
  String get loading => 'ロード中...';

  @override
  String get ee_omori => 'オモリ🔪';

  @override
  String get ee_sunny => 'サニー☀';

  @override
  String get ee_aubrey => 'オーブリー🍆';

  @override
  String get ee_kel => 'ケル🏀';

  @override
  String get ee_hero => 'ヒロ🍳';

  @override
  String get ee_basil => 'バジル🌸';

  @override
  String get ee_mari => 'マリ🧺';
}
