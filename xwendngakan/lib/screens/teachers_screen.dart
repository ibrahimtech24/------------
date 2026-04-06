import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../data/constants.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('مامۆستاکان'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [const Color(0xFFEFF6FF), const Color(0xFFF0F9FF), const Color(0xFFE0E7FF)],
          ),
        ),
        child: SafeArea(
          child: const TeacherListView(),
        ),
      ),
    );
  }
}

// ===============================================
// Teacher List View
// ===============================================
class TeacherListView extends StatefulWidget {
  const TeacherListView({super.key});

  @override
  State<TeacherListView> createState() => _TeacherListViewState();
}

class _TeacherListViewState extends State<TeacherListView> {
  List<Map<String, dynamic>> _teachers = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _selectedFilter = 'all'; // all, university, school

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final teachers = await ApiService.getTeachers(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        type: _selectedFilter == 'all' ? null : _selectedFilter,
      );
      if (mounted) {
        setState(() {
          _teachers = teachers;
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
        // Search Bar
        GlassContainer(
          borderRadius: 0,
          blur: 20,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'گەڕان بە ناو، شار...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _loadTeachers();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _loadTeachers(),
              ),
              const SizedBox(height: 12),
              // Filter Tabs
              Row(
                children: [
                  _buildFilterTab('👨‍🏫 هەمووی', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterTab('🎓 زانکۆ', 'university'),
                  const SizedBox(width: 8),
                  _buildFilterTab('🏫 قوتابخانە', 'school'),
                ],
              ),
            ],
          ),
        ),

     

        // Teacher List
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildFilterTab(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedFilter = value);
          _loadTeachers();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 64, color: AppTheme.danger.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadTeachers,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('هەوڵدانەوە'),
            ),
          ],
        ),
      );
    }

    if (_teachers.isEmpty) {
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
              child: Icon(Icons.person_search_rounded,
                  size: 64, color: AppTheme.primary.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              'هیچ ماموستایەک نەدۆزرایەوە',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'یەکەمین بە بۆ تۆمارکردنی خۆت!',
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTeachers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _teachers.length,
        itemBuilder: (context, index) {
          return _buildTeacherCard(_teachers[index]);
        },
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    final name = teacher['name'] ?? '';
    final typeLabel = teacher['type_label'] ?? '';
    final city = teacher['city'] ?? '';
    final experienceYears = teacher['experience_years'];
    final hourlyRate = teacher['hourly_rate'];
    final photo = teacher['photo'];
    final type = teacher['type'] ?? '';

    final typeColor = type == 'university' ? AppTheme.primary : AppTheme.success;
    final typeEmoji = type == 'university' ? '🎓' : '🏫';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 16,
        blur: 20,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showTeacherDetails(teacher),
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
                      colors: [AppTheme.primary, const Color(0xFF60A5FA)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    image: photo != null && photo.toString().isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                                '${ApiService.serverBase}$photo'),
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
                          Text(typeEmoji, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              typeLabel,
                              style: TextStyle(
                                fontSize: 13,
                                color: typeColor,
                                fontWeight: FontWeight.w500,
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
                            _buildTag(
                                city, Icons.location_on_rounded, AppTheme.accent),
                          if (experienceYears != null && experienceYears > 0)
                            _buildTag('$experienceYears ساڵ ئەزموون',
                                Icons.workspace_premium_rounded, AppTheme.success),
                          if (hourlyRate != null && hourlyRate > 0)
                            _buildTag('$hourlyRate دینار/کاتژمێر',
                                Icons.payments_rounded, AppTheme.primary),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
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

  void _showTeacherDetails(Map<String, dynamic> teacher) {
    final name = teacher['name'] ?? '';
    final typeLabel = teacher['type_label'] ?? '';
    final city = teacher['city'] ?? '';
    final phone = teacher['phone'] ?? '';
    final experienceYears = teacher['experience_years'];
    final hourlyRate = teacher['hourly_rate'];
    final about = teacher['about'] ?? '';
    final photo = teacher['photo'];
    final type = teacher['type'] ?? '';

    final typeColor = type == 'university' ? AppTheme.primary : AppTheme.success;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          final isDarkSheet = Theme.of(context).brightness == Brightness.dark;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkSheet
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [const Color(0xFFEFF6FF), const Color(0xFFF0F9FF)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
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
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primary, const Color(0xFF60A5FA)],
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
                                    image: NetworkImage(
                                        '${ApiService.serverBase}$photo'),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: photo == null || photo.toString().isEmpty
                              ? Center(
                                  child: Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
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
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Info Cards
                        _buildDetailSection(
                          title: 'زانیاری',
                          icon: Icons.info_outline_rounded,
                          color: AppTheme.primary,
                          children: [
                            _buildDetailRow(
                                Icons.location_on_rounded, 'شار', city),
                            if (experienceYears != null &&
                                experienceYears > 0)
                              _buildDetailRow(
                                  Icons.workspace_premium_rounded,
                                  'ئەزموون',
                                  '$experienceYears ساڵ'),
                            if (hourlyRate != null && hourlyRate > 0)
                              _buildDetailRow(Icons.payments_rounded,
                                  'نرخی کاتژمێرێک', '$hourlyRate دینار'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailSection(
                          title: 'پەیوەندی',
                          icon: Icons.phone_rounded,
                          color: AppTheme.success,
                          children: [
                            _buildDetailRow(
                                Icons.phone_rounded, 'تەلەفۆن', phone),
                          ],
                        ),
                        if (about.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildDetailSection(
                            title: 'دەربارە',
                            icon: Icons.person_rounded,
                            color: AppTheme.accent,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  about,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return GlassContainer(
      borderRadius: 16,
      blur: 20,
      child: SizedBox(
        width: double.infinity,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================
// Teacher Registration Form
// ===============================================
class TeacherFormView extends StatefulWidget {
  const TeacherFormView({super.key});

  @override
  State<TeacherFormView> createState() => _TeacherFormViewState();
}

class _TeacherFormViewState extends State<TeacherFormView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _aboutController = TextEditingController();

  String? _selectedType;
  String? _selectedCity;
  File? _photo;
  File? _subjectPhoto;

  final List<String> _cities =
      AppConstants.cities['عێراق'] ?? [];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _hourlyRateController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('تۆمارکردنی ماموستا'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 28),

                // Section: Teacher Info
                _buildSectionTitle('📝', 'تۆمارکردنی ماموستا'),
                const SizedBox(height: 6),
                Text(
                  'ئەگەر ماموستای تایبەتیت، خۆت تۆمار بکە تا قوتابیان بتدۆزنەوە.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: 'ناوی سیانی',
                  hint: 'ناوی تەواو...',
                  prefixIcon: Icons.person_outline_rounded,
                  isRequired: true,
                ),
                const SizedBox(height: 12),

                // Phone
                _buildTextField(
                  controller: _phoneController,
                  label: 'ژمارەی تەلەفۆن',
                  hint: '07XX XXX XXXX',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                ),
                const SizedBox(height: 12),

                // Type
                _buildDropdown(
                  label: 'جۆری ماموستا',
                  value: _selectedType,
                  items: const ['ماموستای زانکۆ', 'ماموستای قوتابخانە'],
                  onChanged: (v) => setState(() => _selectedType = v),
                  isRequired: true,
                ),
                const SizedBox(height: 12),

                // City
                _buildDropdown(
                  label: 'شار',
                  value: _selectedCity,
                  items: _cities,
                  onChanged: (v) => setState(() => _selectedCity = v),
                  isRequired: true,
                ),
                const SizedBox(height: 12),

                // Experience & Rate
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _experienceController,
                        label: 'ساڵانی ئەزموون',
                        hint: '٥',
                        prefixIcon: Icons.workspace_premium_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _hourlyRateController,
                        label: 'نرخی کاتژمێرێک',
                        hint: '١٠,٠٠٠',
                        prefixIcon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // About
                _buildTextField(
                  controller: _aboutController,
                  label: 'دەربارەی خۆت',
                  hint: 'کورتەیەک دەربارەی ئەزموون و شارەزاییەکانت...',
                  prefixIcon: Icons.info_outline_rounded,
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                // Photos
                _buildSectionTitle('📸', 'وێنەکان'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPhotoPicker(
                        label: 'وێنەی ماموستا',
                        file: _photo,
                        onPick: () => _pickImage((f) => setState(() => _photo = f)),
                        onClear: () => setState(() => _photo = null),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPhotoPicker(
                        label: 'وێنەی بابەت',
                        file: _subjectPhoto,
                        onPick: () => _pickImage((f) => setState(() => _subjectPhoto = f)),
                        onClear: () => setState(() => _subjectPhoto = null),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Submit
                _buildSubmitButton(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, const Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📨 تۆمارکردنی ماموستا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'زانیاریەکانت پڕبکەوە تا قوتابیان بتدۆزنەوە',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(void Function(File) onPicked) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      onPicked(File(result.files.single.path!));
    }
  }

  Widget _buildPhotoPicker({
    required String label,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: file != null
                ? AppTheme.primary
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFFE8ECF0)),
            width: file != null ? 1.5 : 1,
          ),
        ),
        child: file != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.danger,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: AppTheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: AppTheme.primary, size: 22),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE8ECF0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.danger),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 14 : 0,
        ),
      ),
      validator: isRequired
          ? (value) => value?.trim().isEmpty ?? true ? 'پێویستە' : null
          : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE8ECF0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Theme.of(context).cardColor,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppTheme.primary.withOpacity(0.7),
      ),
      validator: isRequired
          ? (value) => value == null ? 'پێویستە' : null
          : null,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          disabledBackgroundColor: AppTheme.primary.withOpacity(0.6),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 20),
                  SizedBox(width: 10),
                  Text(
                    '📨 تۆمارکردنی ماموستا',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // Map type from Kurdish to English
    String? mappedType;
    if (_selectedType == 'ماموستای زانکۆ') {
      mappedType = 'university';
    } else if (_selectedType == 'ماموستای قوتابخانە') {
      mappedType = 'school';
    }

    try {
      final result = await ApiService.submitTeacher(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        type: mappedType ?? '',
        city: _selectedCity ?? '',
        experienceYears: _experienceController.text.trim().isEmpty
            ? null
            : int.tryParse(_experienceController.text.trim()),
        hourlyRate: _hourlyRateController.text.trim().isEmpty
            ? null
            : int.tryParse(
                _hourlyRateController.text.trim().replaceAll(',', '')),
        about: _aboutController.text.trim(),
        photo: _photo,
        subjectPhoto: _subjectPhoto,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        _showSuccessDialog();
        _clearForm();
      } else {
        _showErrorSnackbar(result['message'] ?? 'هەڵەیەک ڕوویدا');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar('تکایە پەیوەندیت بە ئینتەرنێت هەبێت');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _experienceController.clear();
    _hourlyRateController.clear();
    _aboutController.clear();
    setState(() {
      _selectedType = null;
      _selectedCity = null;
      _photo = null;
      _subjectPhoto = null;
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.success, const Color(0xFF34D399)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.success.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'سەرکەوتوو بوو! 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'تۆمارکردنت بە سەرکەوتوویی ئەنجامدرا.\nدوای پەسەندکردنی ئەدمین زانیاریەکانت بڵاو دەبێتەوە.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'باشە',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
