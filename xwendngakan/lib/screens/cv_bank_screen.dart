import 'package:flutter/material.dart';
import '../widgets/cv_form_screen.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class CvBankScreen extends StatefulWidget {
  const CvBankScreen({super.key});

  @override
  State<CvBankScreen> createState() => _CvBankScreenState();
}

class _CvBankScreenState extends State<CvBankScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' CV'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              icon: Icon(Icons.add_circle_outline_rounded),
              text: 'تۆمارکردنی CV',
            ),
            Tab(
              icon: Icon(Icons.people_alt_rounded),
              text: 'بینینی CVکان',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CvFormScreen(),
          CvListView(),
        ],
      ),
    );
  }
}

// ===============================================
// CV List View - Shows all submitted CVs
// ===============================================
class CvListView extends StatefulWidget {
  const CvListView({super.key});

  @override
  State<CvListView> createState() => _CvListViewState();
}

class _CvListViewState extends State<CvListView> {
  List<Map<String, dynamic>> _cvs = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String? _selectedCity;
  String? _selectedEducationLevel;

  @override
  void initState() {
    super.initState();
    _loadCvs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCvs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cvs = await ApiService.getCvs(
        search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        city: _selectedCity,
        educationLevel: _selectedEducationLevel,
      );
      if (mounted) {
        setState(() {
          _cvs = cvs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'هەڵە لە بارکردنی داتاکان';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search & Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search Field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'گەڕان بە ناو، بوار، بەهرە...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _loadCvs();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _loadCvs(),
              ),
              const SizedBox(height: 12),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: _selectedEducationLevel ?? 'ئاستی خوێندن',
                      isSelected: _selectedEducationLevel != null,
                      onTap: () => _showEducationLevelPicker(),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedCity != null || _selectedEducationLevel != null)
                      ActionChip(
                        avatar: const Icon(Icons.clear, size: 16),
                        label: const Text('پاککردنەوە'),
                        onPressed: () {
                          setState(() {
                            _selectedCity = null;
                            _selectedEducationLevel = null;
                          });
                          _loadCvs();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stats Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.people_alt_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${_cvs.length} CV',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _loadCvs,
                tooltip: 'نوێکردنەوە',
              ),
            ],
          ),
        ),

        // CV List
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppTheme.danger.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadCvs,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('هەوڵدانەوە'),
            ),
          ],
        ),
      );
    }

    if (_cvs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 64,
                color: AppTheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'هیچ CVیەک نەدۆزرایەوە',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'یەکەمین بە بۆ تۆمارکردنی CVت!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCvs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cvs.length,
        itemBuilder: (context, index) {
          final cv = _cvs[index];
          return _buildCvCard(cv);
        },
      ),
    );
  }

  Widget _buildCvCard(Map<String, dynamic> cv) {
    final name = cv['name'] ?? '';
    final field = cv['field'] ?? '';
    final city = cv['city'] ?? '';
    final educationLevel = cv['education_level'] ?? '';
    final photo = cv['photo'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCvDetails(cv),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    image: photo != null && photo.toString().isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage('${ApiService.serverBase}$photo'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photo == null || photo.toString().isEmpty
                      ? Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 14,
                            color: AppTheme.primary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              field,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (city.isNotEmpty)
                            _buildTag(city, Icons.location_on_rounded, AppTheme.accent),
                          if (educationLevel.isNotEmpty)
                            _buildTag(educationLevel, Icons.trending_up_rounded, AppTheme.success),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school_rounded,
              size: 16,
              color: isSelected ? Colors.white : AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isSelected ? Colors.white : AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showEducationLevelPicker() {
    final levels = [
      'پۆلی یەکەم',
      'پۆلی دووەم',
      'پۆلی سێیەم',
      'پۆلی چوارەم',
      'دەرچوو',
      'ماستەر',
      'دکتۆرا',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ئاستی خوێندن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...levels.map((level) => ListTile(
                title: Text(level),
                trailing: _selectedEducationLevel == level
                    ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedEducationLevel = level);
                  Navigator.pop(context);
                  _loadCvs();
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _showCvDetails(Map<String, dynamic> cv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Profile Header
                        _buildProfileHeader(cv),
                        const SizedBox(height: 24),
                        // Contact Section
                        _buildInfoSection(
                          title: 'پەیوەندی',
                          icon: Icons.contact_phone_rounded,
                          color: AppTheme.primary,
                          items: [
                            if (cv['phone'] != null)
                              _buildInfoRow(Icons.phone_rounded, 'تەلەفۆن', cv['phone']),
                            if (cv['email'] != null && cv['email'].toString().isNotEmpty)
                              _buildInfoRow(Icons.email_rounded, 'ئیمەیڵ', cv['email']),
                            if (cv['city'] != null)
                              _buildInfoRow(Icons.location_city_rounded, 'شار', cv['city']),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Education Section
                        _buildInfoSection(
                          title: 'خوێندن',
                          icon: Icons.school_rounded,
                          color: AppTheme.success,
                          items: [
                            if (cv['field'] != null)
                              _buildInfoRow(Icons.auto_stories_rounded, 'بوار', cv['field']),
                            if (cv['education_level'] != null && cv['education_level'].toString().isNotEmpty)
                              _buildInfoRow(Icons.trending_up_rounded, 'ئاست', cv['education_level']),
                            if (cv['graduation_year'] != null && cv['graduation_year'].toString().isNotEmpty)
                              _buildInfoRow(Icons.calendar_month_rounded, 'ساڵی دەرچوون', cv['graduation_year']),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Skills & Experience
                        if (cv['skills'] != null && cv['skills'].toString().isNotEmpty) ...[
                          _buildTextSection(
                            title: 'بەهرەکان',
                            icon: Icons.psychology_rounded,
                            color: AppTheme.accent,
                            content: cv['skills'],
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (cv['experience'] != null && cv['experience'].toString().isNotEmpty) ...[
                          _buildTextSection(
                            title: 'ئەزموون',
                            icon: Icons.work_rounded,
                            color: AppTheme.warning,
                            content: cv['experience'],
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (cv['notes'] != null && cv['notes'].toString().isNotEmpty) ...[
                          _buildTextSection(
                            title: 'تێبینی',
                            icon: Icons.note_rounded,
                            color: Colors.grey,
                            content: cv['notes'],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> cv) {
    final name = cv['name'] ?? '';
    final field = cv['field'] ?? '';
    final photo = cv['photo'];
    final genderLabel = cv['gender_label'] ?? '';
    final age = cv['age'];

    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, AppTheme.accent],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            image: photo != null && photo.toString().isNotEmpty
                ? DecorationImage(
                    image: NetworkImage('${ApiService.serverBase}$photo'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photo == null || photo.toString().isEmpty
              ? Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          field,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            if (age != null)
              _buildHeaderTag('$age ساڵ', Icons.cake_rounded),
            if (genderLabel.isNotEmpty)
              _buildHeaderTag(genderLabel, Icons.person_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
