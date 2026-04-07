import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/institution.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_snackbar.dart';
import 'register_screen.dart';
import 'edit_screen.dart';
import 'detail_screen.dart';

class InstitutionDashboardScreen extends StatefulWidget {
  final Institution? initialInstitution;
  final VoidCallback onInstitutionCreated;

  const InstitutionDashboardScreen({
    super.key,
    this.initialInstitution,
    required this.onInstitutionCreated,
  });

  @override
  State<InstitutionDashboardScreen> createState() => _InstitutionDashboardScreenState();
}

class _InstitutionDashboardScreenState extends State<InstitutionDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Admin institutions tab state
  List<Institution> _adminInstitutions = [];
  Map<String, dynamic> _meta = {};
  bool _isLoadingAdmin = true;
  String _filterStatus = 'pending'; // 'pending' | 'approved' | 'all'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAdminInstitutions();
  }

  Future<void> _loadAdminInstitutions() async {
    setState(() => _isLoadingAdmin = true);
    try {
      final result = await ApiService.getAdminInstitutions(status: _filterStatus);
      if (!mounted) return;
      setState(() {
        _adminInstitutions = List<Institution>.from(result['institutions'] ?? []);
        _meta = Map<String, dynamic>.from(result['meta'] ?? {});
        _isLoadingAdmin = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingAdmin = false);
    }
  }

  Future<void> _toggleApproval(Institution inst) async {
    final res = await ApiService.toggleInstitutionApproval(inst.id);
    if (!mounted) return;
    if (res['success'] == true) {
      AppSnackbar.success(context, res['message'] ?? 'نوێکرایەوە');
      _loadAdminInstitutions();
    } else {
      AppSnackbar.error(context, res['message'] ?? 'هەڵەیەک ڕوویدا');
    }
  }

  Future<void> _deleteInstitution(Institution inst) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('سڕینەوە'),
        content: Text('دڵنیایت لە سڕینەوەی "${inst.displayName}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('نەخێر')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بەڵێ، بیسڕەوە', style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await ApiService.adminDeleteInstitution(inst.id);
    if (!mounted) return;
    if (ok) {
      AppSnackbar.success(context, 'دامەزراوەکە سڕایەوە');
      _loadAdminInstitutions();
    } else {
      AppSnackbar.error(context, 'سڕینەوە سەرکەوتوو نەبوو');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('پڕۆفایلی دامەزراوەکەم'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          tabs: const [
            Tab(
              icon: Icon(Iconsax.building, size: 20),
              text: 'دامەزراوە',
            ),
            Tab(
              icon: Icon(Iconsax.document_text, size: 20),
              text: 'پۆستەکان',
            ),
            Tab(
              icon: Icon(Iconsax.task_square, size: 20),
              text: 'داواکاریەکان',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Tab 1: Edit or Register ──
          widget.initialInstitution != null
              ? EditScreen(
                  institution: widget.initialInstitution!,
                  hideAppBar: true,
                )
              : RegisterScreen(
                  onSubmitted: widget.onInstitutionCreated,
                ),

          // ── Tab 2: Posts ──
          widget.initialInstitution != null
              ? DetailScreen(
                  institution: widget.initialInstitution!,
                )
              : _buildEmptyPostsState(isDark),

          // ── Tab 3: Admin Institutions ──
          _buildAdminTab(isDark),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Tab 3 — Admin Institutions
  // ─────────────────────────────────────────────
  Widget _buildAdminTab(bool isDark) {
    return Column(
      children: [
        // Filter chips row
        _buildFilterRow(isDark),
        // Stats bar
        _buildStatsBar(isDark),
        // List
        Expanded(
          child: _isLoadingAdmin
              ? const Center(child: CircularProgressIndicator())
              : _adminInstitutions.isEmpty
                  ? _buildEmptyAdminState(isDark)
                  : RefreshIndicator(
                      onRefresh: _loadAdminInstitutions,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _adminInstitutions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) =>
                            _buildInstitutionCard(_adminInstitutions[i], isDark),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterRow(bool isDark) {
    final filters = [
      ('pending', 'چاوەڕوان', Iconsax.clock),
      ('approved', 'پاساو', Iconsax.tick_circle),
      ('all', 'هەموو', Iconsax.element_4),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Row(
        children: [
          ...filters.map((f) {
            final isSelected = _filterStatus == f.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_filterStatus == f.$1) return;
                  setState(() => _filterStatus = f.$1);
                  _loadAdminInstitutions();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        f.$3,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        f.$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsBar(bool isDark) {
    final pending = _meta['pending'] ?? 0;
    final approved = _meta['approved'] ?? 0;
    final total = _meta['total'] ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [AppTheme.primary.withValues(alpha: 0.05), AppTheme.primary.withValues(alpha: 0.12)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppTheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('هەموو', total.toString(), AppTheme.primary, isDark),
          _divider(isDark),
          _statItem('چاوەڕوان', pending.toString(), AppTheme.warning, isDark),
          _divider(isDark),
          _statItem('پاساو', approved.toString(), AppTheme.success, isDark),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      height: 36,
      width: 1,
      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildInstitutionCard(Institution inst, bool isDark) {
    final isApproved = inst.approved;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApproved
              ? AppTheme.success.withValues(alpha: 0.3)
              : AppTheme.warning.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                // Logo or placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    image: inst.logo.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(inst.logo),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: inst.logo.isEmpty
                      ? Center(
                          child: Text(
                            inst.displayName.isNotEmpty
                                ? inst.displayName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inst.displayName.isNotEmpty ? inst.displayName : 'بی ناو',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (inst.city.isNotEmpty) ...[
                            Icon(
                              Iconsax.location,
                              size: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              inst.city,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            inst.type,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isApproved
                        ? AppTheme.success.withValues(alpha: 0.12)
                        : AppTheme.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isApproved ? 'پاساو' : 'چاوەڕوان',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isApproved ? AppTheme.success : AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contact info row
          if (inst.phone.isNotEmpty || inst.email.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Row(
                children: [
                  if (inst.phone.isNotEmpty)
                    _infoChip(Iconsax.call, inst.phone, isDark),
                  if (inst.phone.isNotEmpty && inst.email.isNotEmpty)
                    const SizedBox(width: 8),
                  if (inst.email.isNotEmpty)
                    Expanded(
                      child: _infoChip(Iconsax.sms, inst.email, isDark, overflow: true),
                    ),
                ],
              ),
            ),

          // Divider
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              children: [
                // Toggle Approval
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _toggleApproval(inst),
                    icon: Icon(
                      isApproved ? Iconsax.close_circle : Iconsax.tick_circle,
                      size: 16,
                      color: isApproved ? AppTheme.warning : AppTheme.success,
                    ),
                    label: Text(
                      isApproved ? 'ڕەتکردنەوە' : 'پاساودان',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isApproved ? AppTheme.warning : AppTheme.success,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                Container(width: 1, height: 28, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                // Delete
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _deleteInstitution(inst),
                    icon: const Icon(Iconsax.trash, size: 16, color: AppTheme.danger),
                    label: const Text(
                      'سڕینەوە',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.danger,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, bool isDark, {bool overflow = false}) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        overflow
            ? Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildEmptyAdminState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.buildings, size: 56, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              _filterStatus == 'pending'
                  ? 'هیچ داواکارییەکی چاوەڕوان نییە'
                  : _filterStatus == 'approved'
                      ? 'هیچ دامەزراوەیەکی پاساو نییە'
                      : 'هیچ دامەزراوەیەک نییە',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadAdminInstitutions,
              icon: const Icon(Iconsax.refresh, size: 18),
              label: const Text('نوێکردنەوە'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Tab 2 — Empty posts placeholder
  // ─────────────────────────────────────────────
  Widget _buildEmptyPostsState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.info_circle,
                size: 64,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'سەرەتا دامەزراوەکەت زیاد بکە',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'دەبێت لە تابی (دامەزراوە) فۆڕمەکە پڕبکەیتەوە و دامەزراوەکەت تۆمار بکەیت پێش ئەوەی بتوانیت پۆست بکەیت.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('بڕۆ بۆ تۆمارکردن'),
            ),
          ],
        ),
      ),
    );
  }
}
