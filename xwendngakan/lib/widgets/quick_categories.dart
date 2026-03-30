import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../services/app_localizations.dart';
import '../theme/app_theme.dart';

class QuickCategories extends StatelessWidget {
  final AppProvider prov;
  final bool isDark;

  const QuickCategories({
    super.key,
    required this.prov,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = prov.tabs;
    final typeColors = <String, List<Color>>{
      'all': [AppTheme.primary, AppTheme.accent],
      'gov': [const Color(0xFF001d3d), const Color(0xFF003f88)],
      'priv': [const Color(0xFF3b0764), const Color(0xFF8b5cf6)],
      'inst5': [const Color(0xFF0c4a6e), const Color(0xFF0ea5e9)],
      'inst2': [const Color(0xFF134e4a), const Color(0xFF22d3ee)],
      'school': [const Color(0xFF451a03), const Color(0xFFf59e0b)],
      'kg': [const Color(0xFF500724), const Color(0xFFf472b6)],
      'dc': [const Color(0xFF431407), const Color(0xFFfb923c)],
      'lang': [const Color(0xFF022c22), const Color(0xFF2dd4bf)],
      'edu': [const Color(0xFF1a2e05), const Color(0xFF84cc16)],
      'eve_uni': [const Color(0xFF1e1b4b), const Color(0xFF818cf8)],
      'eve_inst': [const Color(0xFF172554), const Color(0xFF60a5fa)],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.accent, AppTheme.primary],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                S.of(context, 'categories'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: tabs.length,
            itemBuilder: (context, i) {
              final tab = tabs[i];
              final key = tab['id'] as String;
              final isOn = prov.currentTab == key;
              final label = prov.localizedField(tab, 'label');
              final cleanLabel = label.replaceFirst(RegExp(r'^[^\s]+\s'), '').trim();
              final colors = typeColors[key] ?? [const Color(0xFF374151), const Color(0xFF6B7280)];

              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: GestureDetector(
                  onTap: () => prov.setTab(key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isOn
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: colors,
                            )
                          : null,
                      color: isOn ? null : (isDark ? const Color(0xFF161B22) : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: isOn
                          ? null
                          : Border.all(
                              color: isDark
                                  ? const Color(0xFF30363D)
                                  : const Color(0xFFE2E8F0),
                            ),
                    ),
                    child: Center(
                      child: Text(
                        cleanLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isOn ? FontWeight.w700 : FontWeight.w500,
                          color: isOn
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xFF475569)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
