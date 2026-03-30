import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../data/constants.dart';
import '../theme/app_theme.dart';

class SubTabsBar extends StatelessWidget {
  final AppProvider prov;
  final bool isDark;

  const SubTabsBar({
    super.key,
    required this.prov,
    required this.isDark,
  });

  List<Map<String, dynamic>>? _getSubTabs(String tabId) {
    final tab = AppConstants.tabDefs.where((t) => t['id'] == tabId).firstOrNull;
    if (tab == null || tab['subs'] == null) return null;
    return (tab['subs'] as List).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    final subs = _getSubTabs(prov.currentTab);
    if (subs == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: subs.map((sub) {
          final isOn = prov.currentSub == sub['id'] ||
              (prov.currentSub.isEmpty && (sub['id'] as String).contains('_all'));
          final cnt = prov.subTabCount(sub['id'] as String);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => prov.setSub(sub['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isOn
                      ? LinearGradient(colors: [
                          AppTheme.accent.withValues(alpha: 0.18),
                          AppTheme.accent.withValues(alpha: 0.06),
                        ])
                      : null,
                  color: isOn ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOn
                        ? AppTheme.accent.withValues(alpha: 0.5)
                        : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB)),
                    width: isOn ? 1.5 : 1,
                  ),
                  boxShadow: isOn
                      ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Text(
                  '${prov.localizedField(sub, 'label')} ($cnt)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isOn ? FontWeight.w800 : FontWeight.w500,
                    color: isOn
                        ? AppTheme.accent
                        : (isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool hasSubTabs(String tabId) => _getSubTabs(tabId) != null;
}
