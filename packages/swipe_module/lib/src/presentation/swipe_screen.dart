// screens/swipe/swipe_screen.dart

import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/swipe_provider.dart';
import 'widgets/swipe_card.dart';
import 'widgets/swipe_buttons.dart';
import 'widgets/swipe_info_chip.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SwipeProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Descobrir',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: Consumer<SwipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () => provider.initialize(),
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (!provider.hasBusinesses) {
            return _buildEmptyState();
          }

          final currentPlace = provider.currentBusinesses!;

          return Column(
            children: [
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SwipeInfoChip(
                  remainingCount: provider.remainingCount,
                  onInfoTap: _showInfo,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SwipeCard(
                    place: _entityToMap(currentPlace),
                    onTap: () => _navigateToDetails(currentPlace.id),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: SwipeButtons(
                  onDislike: () => provider.dislike('current_user_id'),
                  onSuperLike: () => provider.superLike('current_user_id'),
                  onLike: () => provider.like('current_user_id'),
                  onInfo: () => _navigateToDetails(currentPlace.id),
                ),
              ),
              SizedBox(height: 32),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_off, size: 80, color: AppColors.border),
          SizedBox(height: 16),
          Text(
            'Não há mais lugares para descobrir',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Volte mais tarde para ver novos lugares',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<SwipeProvider>().initialize(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Recarregar'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _entityToMap(place) {
    return {
      'id': place.id,
      'name': place.name,
      'category': place.category,
      'description': place.description,
      'rating': place.rating,
      'priceRange': place.priceRange,
      'distance': place.distance,
      'tags': place.tags,
      'images': place.images,
      'discount': place.discount,
      'isOpen': place.isOpen,
    };
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Como funciona?'),
        content: Text(
          'Deslize para a direita (ou clique no coração) para curtir um lugar.\n\n'
          'Deslize para a esquerda (ou clique no X) para passar.\n\n'
          'Clique na estrela para dar super like!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _openFilters() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Filtros em breve')));
  }

  void _navigateToDetails(String placeId) {
    NavigationHelpers.navigateToBusinessesDetails(context, placeId);
  }

  void _onNavBarTap(int index) {
    if (index == 2) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, RouteConstants.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, RouteConstants.discover);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, RouteConstants.map);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, RouteConstants.profile);
        break;
    }
  }
}
