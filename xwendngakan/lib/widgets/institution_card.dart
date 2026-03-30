import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../data/constants.dart';
import '../models/institution.dart';
import '../providers/app_provider.dart';

class InstitutionCard extends StatefulWidget {
  final Institution institution;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const InstitutionCard({
    super.key,
    required this.institution,
    required this.onTap,
    required this.onEdit,
  });

  @override
  State<InstitutionCard> createState() => _InstitutionCardState();
}

class _InstitutionCardState extends State<InstitutionCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = AppConstants.typeGradients[widget.institution.type] ??
        [Colors.grey.shade700, Colors.grey.shade500, Colors.grey.shade300];
    final emoji = AppConstants.typeEmojis[widget.institution.type] ?? '📌';
    final label = context.read<AppProvider>().typeLabel(widget.institution.type);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE8EDF5);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ──
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.institution.logo.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(6),
                              child: CachedNetworkImage(
                                imageUrl: widget.institution.logo,
                                fit: BoxFit.contain,
                                errorWidget: (_, __, ___) => Center(
                                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(emoji, style: const TextStyle(fontSize: 22)),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // ── Name ──
                Text(
                  widget.institution.nameForLang(context.read<AppProvider>().language),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                // ── City ──
                Text(
                  widget.institution.city,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(List<Color> colors, String emoji, bool isDark) {
    if (widget.institution.logo.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.institution.logo,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _buildGradientBg(colors, emoji),
        progressIndicatorBuilder: (_, __, progress) {
          return Container(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
            child: const Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }
    return _buildGradientBg(colors, emoji);
  }

  Widget _buildGradientBg(List<Color> colors, String emoji) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[0],
            colors.length > 1 ? colors[1] : colors[0],
            colors.length > 2 ? colors[2] : colors[0],
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: -10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Center(
            child: Text(emoji, style: const TextStyle(fontSize: 30)),
          ),
        ],
      ),
    );
  }
}
