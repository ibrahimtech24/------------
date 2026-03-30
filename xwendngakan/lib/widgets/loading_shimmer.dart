import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final bool isDark;

  const LoadingShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final base = isDark ? const Color(0xFF21262D) : const Color(0xFFE2E8F0);
    final highlight = isDark ? const Color(0xFF30363D) : const Color(0xFFF8FAFC);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161B22) : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: base,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 10,
                          width: 80,
                          decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(6)),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              height: 22,
                              width: 48,
                              decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(11)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 22,
                              width: 36,
                              decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
