import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/app_provider.dart';
import '../services/app_localizations.dart';
import '../widgets/institution_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFF);
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white : Colors.black38;

    final favorites = prov.favoriteInstitutions;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context, 'favorites'),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? _buildEmptyState(textColor, hintColor)
          : _buildFavoritesList(context, favorites, isDark),
    );
  }

  Widget _buildEmptyState(Color textColor, Color hintColor) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.heart,
              size: 64,
              color: hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context, 'noFavorites'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                S.of(context, 'noFavoritesDesc'),
                style: TextStyle(color: hintColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    List favorites,
    bool isDark,
  ) {
    final screenW = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenW > 600 ? 3 : 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.2,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final inst = favorites[index];
        return InstitutionCard(
          institution: inst,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(institution: inst)),
          ),
          onEdit: () {}, // Favorites screen doesn't need edit functionality
        );
      },
    );
  }
}
