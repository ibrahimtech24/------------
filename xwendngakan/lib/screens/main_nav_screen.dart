import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../services/app_localizations.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'full_map_screen.dart';
import 'register_screen.dart';
import 'settings_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<AnimationController> _iconControllers;
  late final List<Animation<double>> _iconAnimations;
  late final List<Widget> _screens;

  List<_NavItemData> _navItems(BuildContext context) => [
    _NavItemData(
      icon: Iconsax.home_2,
      activeIcon: Iconsax.home_25,
      label: S.of(context, 'navHome'),
    ),
    _NavItemData(
      icon: Iconsax.search_normal_1,
      activeIcon: Iconsax.search_favorite,
      label: S.of(context, 'navSearch'),
    ),
    _NavItemData(
      icon: Iconsax.map_1,
      activeIcon: Iconsax.map,
      label: S.of(context, 'navMap'),
    ),
    _NavItemData(
      icon: Iconsax.add_circle,
      activeIcon: Iconsax.add_circle5,
      label: S.of(context, 'navRegister'),
      isCenter: true,
    ),
    _NavItemData(
      icon: Iconsax.setting_2,
      activeIcon: Iconsax.setting_25,
      label: S.of(context, 'navSettings'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const SearchScreen(),
      const FullMapScreen(),
      RegisterScreen(onSubmitted: () => _onTap(0)),
      const SettingsScreen(),
    ];
    _iconControllers = List.generate(
      5,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      ),
    );
    _iconAnimations = _iconControllers.map((c) {
      return Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(parent: c, curve: Curves.easeOutBack),
      );
    }).toList();
    // Set initial active state
    _iconControllers[0].value = 1.0;
  }

  @override
  void dispose() {
    for (final c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.lightImpact();

    // Animate out old, animate in new
    _iconControllers[_currentIndex].reverse();
    _iconControllers[index].forward();

    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        extendBody: false,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D1117) : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: List.generate(_navItems(context).length, (i) {
                  return Expanded(
                    child: _buildNavItem(i, isDark),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark) {
    final item = _navItems(context)[index];
    final isActive = _currentIndex == index;

    if (item.isCenter) {
      return _buildCenterItem(index, isDark);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active indicator line
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isActive ? 20 : 0,
            height: 2.5,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Icon(
            isActive ? item.activeIcon : item.icon,
            size: 22,
            color: isActive
                ? AppTheme.primary
                : (isDark
                    ? const Color(0xFF4A5568)
                    : const Color(0xFFa0aec0)),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? AppTheme.primary
                  : (isDark
                      ? const Color(0xFF4A5568)
                      : const Color(0xFFa0aec0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterItem(int index, bool isDark) {
    final item = _navItems(context)[index];
    final isActive = _currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active indicator line
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isActive ? 20 : 0,
            height: 2.5,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isActive
                    ? [AppTheme.primary, AppTheme.accent]
                    : [
                        AppTheme.primary.withValues(alpha: 0.12),
                        AppTheme.accent.withValues(alpha: 0.12),
                      ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isActive ? item.activeIcon : item.icon,
              size: 20,
              color: isActive
                  ? Colors.white
                  : (isDark
                      ? AppTheme.primary.withValues(alpha: 0.6)
                      : AppTheme.primary.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? AppTheme.primary
                  : (isDark
                      ? const Color(0xFF4A5568)
                      : const Color(0xFFa0aec0)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isCenter;

  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isCenter = false,
  });
}

