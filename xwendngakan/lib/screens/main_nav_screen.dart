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
import 'cv_bank_screen.dart';
import 'teachers_screen.dart';
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
  late final List<Widget> _screens;

  List<_NavItemData> _navItems(BuildContext context) => [
    _NavItemData(
      icon: Iconsax.home_2,
      activeIcon: Iconsax.home_25,
      label: S.of(context, 'navHome'),
    ),
    _NavItemData(
      icon: Iconsax.add_circle,
      activeIcon: Iconsax.add_circle5,
      label: S.of(context, 'navRegister'),
      isCenter: true,
    ),
    _NavItemData(
      icon: Iconsax.document_text,
      activeIcon: Iconsax.document_text_1,
      label: 'سیڤی',
    ),
    _NavItemData(
      icon: Iconsax.teacher,
      activeIcon: Iconsax.teacher,
      label: 'مامۆستا',
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
      RegisterScreen(onSubmitted: () => _onTap(0)),
      const CvBankScreen(),
      const TeachersScreen(),
      const SettingsScreen(),
    ];
    _iconControllers = List.generate(
      5,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      ),
    );
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
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
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
                    ? const Color(0xFFE2E8F0)
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
                      ? const Color(0xFFE2E8F0)
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
                      ? AppTheme.primary.withValues(alpha: 0.9)
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
                      ? const Color(0xFFE2E8F0)
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

// ── Combined Search + Map Screen ────────────────────────────

class _SearchMapScreen extends StatefulWidget {
  const _SearchMapScreen();

  @override
  State<_SearchMapScreen> createState() => _SearchMapScreenState();
}

class _SearchMapScreenState extends State<_SearchMapScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFF);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Toggle strip
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildToggle(0, Iconsax.search_normal_1, 'گەران', isDark),
                    _buildToggle(1, Iconsax.map_1, 'نەخشە', isDark),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: const [
                SearchScreen(),
                FullMapScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(int index, IconData icon, String label, bool isDark) {
    final isActive = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_tab != index) setState(() => _tab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? Colors.white
                    : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? Colors.white
                      : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

