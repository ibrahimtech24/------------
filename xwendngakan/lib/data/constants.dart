import 'package:flutter/material.dart';

class AppConstants {
  // Type labels in Kurdish
  static const Map<String, String> typeLabels = {
    'gov': 'زانکۆ حکومی',
    'priv': 'زانکۆ تایبەت',
    'inst5': 'پەیمانگەی ٥ ساڵی',
    'inst2': 'پەیمانگەی ٢ ساڵی',
    'school': 'قوتابخانە',
    'kg': 'باخچەی منداڵان',
    'dc': 'دایەنگە',
    'lang': 'سەنتەری زمان/پیشەیی',
    'edu': 'کۆمەڵکای پەروەردەیی',
    'eve_uni': 'زانکۆی ئێواران',
    'eve_inst': 'پەیمانگای ئێواران',
  };

  // Type icons
  static const Map<String, IconData> typeIcons = {
    'gov': Icons.school,
    'priv': Icons.account_balance,
    'inst5': Icons.menu_book,
    'inst2': Icons.auto_stories,
    'school': Icons.house_siding,
    'kg': Icons.child_care,
    'dc': Icons.baby_changing_station,
    'lang': Icons.translate,
    'edu': Icons.business,
    'eve_uni': Icons.nightlight_round,
    'eve_inst': Icons.nights_stay,
  };

  // Type emoji
  static const Map<String, String> typeEmojis = {
    'gov': '🎓',
    'priv': '🏛️',
    'inst5': '📘',
    'inst2': '📗',
    'school': '🏫',
    'kg': '🧒',
    'dc': '👶',
    'lang': '📖',
    'edu': '🏢',
    'eve_uni': '🌙',
    'eve_inst': '🌆',
  };

  // Type gradient colors
  static const Map<String, List<Color>> typeGradients = {
    'gov': [Color(0xFF001d3d), Color(0xFF002855), Color(0xFF003f88)],
    'priv': [Color(0xFF3b0764), Color(0xFF6d28d9), Color(0xFF8b5cf6)],
    'inst5': [Color(0xFF0c4a6e), Color(0xFF0369a1), Color(0xFF0ea5e9)],
    'inst2': [Color(0xFF134e4a), Color(0xFF0891b2), Color(0xFF22d3ee)],
    'school': [Color(0xFF451a03), Color(0xFFb45309), Color(0xFFf59e0b)],
    'kg': [Color(0xFF500724), Color(0xFFbe185d), Color(0xFFf472b6)],
    'dc': [Color(0xFF431407), Color(0xFFc2410c), Color(0xFFfb923c)],
    'lang': [Color(0xFF022c22), Color(0xFF0f766e), Color(0xFF2dd4bf)],
    'edu': [Color(0xFF1a2e05), Color(0xFF4d7c0f), Color(0xFF84cc16)],
    'eve_uni': [Color(0xFF1e1b4b), Color(0xFF4338ca), Color(0xFF818cf8)],
    'eve_inst': [Color(0xFF172554), Color(0xFF1e40af), Color(0xFF60a5fa)],
  };

  // Cities
  static const Map<String, List<String>> cities = {
    'عێراق': [
      'هەولێر', 'سلێمانی', 'دهۆک', 'هەڵەبجە', 'گەرمیان', 'ڕاپەڕین', 'زاخۆ',
      'کەلار', 'شەقڵاوە', 'ڕەواندوز', 'کۆیە', 'سۆران', 'ئاکرێ', 'ئامێدی',
      'بەردەڕەش', 'چەمچەماڵ', 'ڕانیە', 'پەنجوێن', 'کفری', 'دەربەندیخان',
      'بەغدا', 'مووسڵ', 'بەسرە', 'کەرکووک', 'نەجەف', 'کەربەلا', 'تکریت',
      'فەڵووجە', 'ڕەمادی', 'حیڵە', 'ناسریە', 'عەمارە', 'سەمایە',
      'دیوانیە', 'کووت', 'بەعقووبە', 'سامەراء', 'عانە', 'هیت', 'پیرمام',
    ],
  };

  // Tab definitions
  static const List<Map<String, dynamic>> tabDefs = [
    {'id': 'all', 'label': '🌟 هەمووی', 'icon': Icons.apps},
    {
      'id': 'gov',
      'label': '🎓 زانکۆ',
      'icon': Icons.school,
      'subs': [
        {'id': 'gov_all', 'label': 'هەمووی'},
        {'id': 'gov_gov', 'label': 'حکومی'},
        {'id': 'gov_priv', 'label': 'تایبەت'},
      ]
    },
    {'id': 'inst2', 'label': '📗 پەیمانگەی ٢ ساڵی', 'icon': Icons.auto_stories},
    {'id': 'inst5', 'label': '📘 پەیمانگەی ٥ ساڵی', 'icon': Icons.menu_book},
    {
      'id': 'school',
      'label': '🏫 قوتابخانە',
      'icon': Icons.house_siding,
      'subs': [
        {'id': 'sch_all', 'label': 'هەمووی'},
        {'id': 'sch_base', 'label': 'بنەڕەتی'},
        {'id': 'sch_prep', 'label': 'ئامادەیی'},
      ]
    },
    {'id': 'kg', 'label': '🧒 باخچەی منداڵان', 'icon': Icons.child_care},
    {'id': 'lang', 'label': '📖 سەنتەری زمان', 'icon': Icons.translate},
    {'id': 'dc', 'label': '👶 دایەنگە', 'icon': Icons.baby_changing_station},
    {'id': 'edu', 'label': '🏢 دامەزراوەی تر', 'icon': Icons.business},
  ];
}
