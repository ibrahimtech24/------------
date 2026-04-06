
import 'dart:ui';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../services/app_localizations.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'cv_bank_screen.dart';
import 'teachers_screen.dart';
import 'settings_screen.dart';

// Move _NavItemData to the top-level
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


class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}


class _MainNavScreenState extends State<MainNavScreen> with TickerProviderStateMixin {
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
    for (final controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _iconControllers[_currentIndex].reverse();
      _currentIndex = index;
      _iconControllers[_currentIndex].forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0), // No vertical padding
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                  color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.02),
                child: GNav(
                  gap: 2, // Closer icons
                  selectedIndex: _currentIndex,
                  onTabChange: (idx) => _onTap(idx),
                  backgroundColor: Colors.transparent,
                  tabBackgroundColor: isDark
                      ? Colors.white.withOpacity(0.08)
                      : AppTheme.primary.withOpacity(0.10),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  tabBorderRadius: 16,
                  color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey.shade600,
                  activeColor: isDark ? Colors.white : AppTheme.primary,
                  iconSize: 20, // Smaller icons
                  textSize: 14,
                  tabs: List.generate(_navItems(context).length, (i) {
                    final item = _navItems(context)[i];
                    return GButton(
                      icon: item.icon,
                      text: item.label,
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}