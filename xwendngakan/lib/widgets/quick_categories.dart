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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.accent, AppTheme.primary],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                S.of(context, 'categories'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 48, // Taller for modern pill shape
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tabs.length,
            itemBuilder: (context, i) {
              final tab = tabs[i];
              final key = tab['id'] as String;
              final isOn = prov.currentTab == key;
              final label = prov.localizedField(tab, 'label');
              final cleanLabel = label.replaceFirst(RegExp(r'^[^\s]+\s'), '').trim();
              final colors = typeColors[key] ?? [AppTheme.primary, AppTheme.accent];

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () => prov.setTab(key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                      gradient: isOn
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: colors,
                            )
                          : null,
                      color: isOn ? null : (isDark ? const Color(0xFF1E293B) : Colors.white),
                      borderRadius: BorderRadius.circular(24),
                      border: isOn
                          ? null
                          : Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                      boxShadow: isOn
                          ? [
                              BoxShadow(
                                color: colors.first.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Center(
                      child: Text(
                        cleanLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isOn ? FontWeight.w800 : FontWeight.w600,
                          color: isOn
                              ? Colors.white
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                          letterSpacing: 0.1,
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
