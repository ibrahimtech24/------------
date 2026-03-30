import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/app_provider.dart';
import '../services/app_localizations.dart';
import '../theme/app_theme.dart';

class GreetingHeader extends StatelessWidget {
  final AppProvider prov;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onShowFavorites;
  final int favoritesCount;

  const GreetingHeader({
    super.key,
    required this.prov,
    required this.isDark,
    required this.onToggleTheme,
    required this.onShowFavorites,
    required this.favoritesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primary, AppTheme.accent],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('📚', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              S.of(context, 'appName'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
          ),
          _buildHeaderIcon(
            icon: isDark ? Iconsax.sun_1 : Iconsax.moon,
            onTap: onToggleTheme,
            iconColor: isDark ? const Color(0xFFFBBF24) : null,
          ),
          const SizedBox(width: 4),
          _buildHeaderIcon(
            icon: favoritesCount > 0 ? Iconsax.heart5 : Iconsax.heart,
            onTap: onShowFavorites,
            iconColor: favoritesCount > 0 ? Colors.redAccent : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
    int? badgeCount,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161B22) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF30363D) : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? (isDark ? const Color(0xFF8B949E) : const Color(0xFF64748B)),
              ),
            ),
            if (badge && badgeCount != null && badgeCount > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
