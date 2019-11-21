import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AnimeLocalizations {
  static Future<AnimeLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AnimeLocalizations();
    });
  }

  static AnimeLocalizations of(BuildContext context) {
    return Localizations.of<AnimeLocalizations>(context, AnimeLocalizations);
  }

  String get dashHome => Intl.message('首页', name: 'dashHome');
  String get dashRecent => Intl.message('最近', name: 'dashRecent');
  String get dashRecommend => Intl.message('推荐', name: 'dashRecommend');
  String get dashClassification =>
      Intl.message('分类', name: 'dashClassification');
  String get homeTitle => Intl.message('追番表', name: 'homeTitle');
  String get recentTitle => Intl.message('最近更新', name: 'recentTitle');
  String get recommendTitle => Intl.message('推荐动漫', name: 'recommendTitle');

  String get monday => Intl.message('周一', name: 'monday');
  String get tuesday => Intl.message('周二', name: 'tuesday');
  String get wednesday => Intl.message('周三', name: 'wednesday');
  String get thursday => Intl.message('周四', name: 'thursday');
  String get friday => Intl.message('周五', name: 'friday');
  String get saturday => Intl.message('周六', name: 'saturday');
  String get sunday => Intl.message('周日', name: 'sunday');

  String get types1 => Intl.message('全部', name: 'types1');
  String get types2 => Intl.message('热血', name: 'types2');
  String get types3 => Intl.message('恋爱', name: 'types3');
  String get types4 => Intl.message('科幻', name: 'types4');
  String get types5 => Intl.message('奇幻', name: 'types5');
  String get types6 => Intl.message('百合', name: 'types6');
  String get types7 => Intl.message('后宫', name: 'types7');
  String get types8 => Intl.message('励志', name: 'types8');
  String get types9 => Intl.message('搞笑', name: 'types9');
  String get types10 => Intl.message('冒险', name: 'types10');
  String get types11 => Intl.message('校园', name: 'types11');
  String get types12 => Intl.message('战斗', name: 'types12');
  String get types13 => Intl.message('机战', name: 'types13');
  String get types14 => Intl.message('运动', name: 'types14');
  String get types15 => Intl.message('战争', name: 'types15');
  String get types16 => Intl.message('萝莉', name: 'types16');
}

class AnimeLocalizationsDelegate
    extends LocalizationsDelegate<AnimeLocalizations> {
  const AnimeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['zh', 'en'].contains(locale.languageCode);

  @override
  Future<AnimeLocalizations> load(Locale locale) =>
      AnimeLocalizations.load(locale);

  @override
  bool shouldReload(AnimeLocalizationsDelegate old) => false;
}
