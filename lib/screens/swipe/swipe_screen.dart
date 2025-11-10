// screens/swipe/swipe_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/widgets/buttons/custom_bottom_nav_bar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../core/constants/routes.dart';
import '../../providers/places_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/place_model.dart';
import '../../widgets/navigation/custom_bottom_nav_bar.dart';
import 'widgets/swipe_card.dart';
import 'widgets/swipe_buttons.dart';
import 'widgets/swipe_info_chip.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;
  List<PlaceModel> _availablePlaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(2.0, 0.0))
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlaces();
    });
  }

  Future<void> _loadPlaces() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('🔄 SwipeScreen: Carregando lugares...');

      final placesProvider = context.read<PlacesProvider>();

      // Carregar lugares se ainda não foram carregados
      if (placesProvider.places.isEmpty) {
        await placesProvider.loadPlaces();
      }

      setState(() {
        _availablePlaces = List.from(placesProvider.places);
        _isLoading = false;
      });

      debugPrint(
        '✅ SwipeScreen: ${_availablePlaces.length} lugares carregados',
      );
    } catch (e) {
      debugPrint('❌ SwipeScreen: Erro ao carregar lugares: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header customizado com gradiente
          _buildHeader(),

          // Conteúdo
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _availablePlaces.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: [
                      // Info Chip
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.horizontalPadding),
                        child: SwipeInfoChip(
                          remainingCount: _availablePlaces.length,
                          onInfoTap: _showSwipeInstructions,
                        ),
                      ),

                      // Cards Stack
                      Expanded(
                        child: Stack(
                          children: [
                            // Card de trás (preview)
                            if (_availablePlaces.length > 1)
                              Positioned.fill(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppSpacing.horizontalPadding + 8,
                                    vertical: 16,
                                  ),
                                  child: Transform.scale(
                                    scale: 0.95,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: SwipeCard(
                                        place: _convertToMap(
                                          _availablePlaces[1],
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Card principal
                            if (_availablePlaces.isNotEmpty)
                              Positioned.fill(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.horizontalPadding,
                                    vertical: 8,
                                  ),
                                  child: _isAnimating
                                      ? SlideTransition(
                                          position: _slideAnimation,
                                          child: SwipeCard(
                                            place: _convertToMap(
                                              _availablePlaces[0],
                                            ),
                                            onTap: () => _navigateToDetails(
                                              _availablePlaces[0].id,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onHorizontalDragEnd: _onDragEnd,
                                          child: SwipeCard(
                                            place: _convertToMap(
                                              _availablePlaces[0],
                                            ),
                                            onTap: () => _navigateToDetails(
                                              _availablePlaces[0].id,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Botões de ação
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.horizontalPadding),
                        child: SwipeButtons(
                          onDislike: _onDislike,
                          onSuperLike: _onSuperLike,
                          onLike: _onLike,
                          onInfo: () =>
                              _navigateToDetails(_availablePlaces[0].id),
                        ),
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: _onNavBarTap,
      ),
    );
  }

  /// Converte PlaceModel para Map (para compatibilidade com SwipeCard)
  Map<String, dynamic> _convertToMap(PlaceModel place) {
    return {
      'id': place.id,
      'name': place.name,
      'category': place.category,
      'images': place.images ?? [],
      'rating': place.rating,
      'distance': place.distance != null ? place.distance! / 1000 : 0.0,
      'priceRange': place.priceRange ?? '\$\$',
      'description': place.description ?? '',
      'tags': place.amenities ?? [],
      'isOpen': place.isOpen,
      'discount': place.discountText,
    };
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.horizontalPadding,
            16,
            AppSpacing.horizontalPadding,
            16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Título e subtítulo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descubra',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Deslize e encontre seu próximo lugar',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),

              // Botão filtros
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.tune, color: Colors.white),
                  onPressed: _openFilters,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Carregando lugares...',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 32),

            // Título
            Text(
              'Você viu tudo!',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),

            // Descrição
            Text(
              'Não há mais lugares para descobrir no momento. Volte mais tarde ou ajuste seus filtros.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32),

            // Botões
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _resetCards,
                    icon: Icon(Icons.refresh),
                    label: Text('Ver novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openFilters,
                    icon: Icon(Icons.tune),
                    label: Text('Ajustar filtros'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary, width: 2),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      _onLike();
    } else if (details.primaryVelocity! < 0) {
      _onDislike();
    }
  }

  void _onDislike() {
    if (_isAnimating || _availablePlaces.isEmpty) return;

    setState(() => _isAnimating = true);

    _animationController.forward().then((_) {
      setState(() {
        _availablePlaces.removeAt(0);
        _isAnimating = false;
      });
      _animationController.reset();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('😕 Não curtiu'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onLike() {
    if (_isAnimating || _availablePlaces.isEmpty) return;

    final place = _availablePlaces[0];

    setState(() => _isAnimating = true);

    final user = context.read<UserProvider>().currentUser;
    if (user != null) {
      context.read<PlacesProvider>().addFavorite(user.id, place.id);
    }

    _animationController.forward().then((_) {
      setState(() {
        _availablePlaces.removeAt(0);
        _isAnimating = false;
      });
      _animationController.reset();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❤️ Adicionado aos favoritos!'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onSuperLike() {
    if (_isAnimating || _availablePlaces.isEmpty) return;

    final place = _availablePlaces[0];

    _navigateToDetails(place.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⭐ Super Like! Veja os detalhes'),
        duration: Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _openFilters() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Filtros em breve')));
  }

  void _showSwipeInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 12),
            Text('Como funciona?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionItem('👈', 'Deslize para esquerda para passar'),
            SizedBox(height: 12),
            _buildInstructionItem('👉', 'Deslize para direita para curtir'),
            SizedBox(height: 12),
            _buildInstructionItem('⭐', 'Toque na estrela para super like'),
            SizedBox(height: 12),
            _buildInstructionItem('ℹ️', 'Toque no card para ver detalhes'),
          ],
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

  Widget _buildInstructionItem(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
        SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ],
    );
  }

  void _resetCards() {
    _loadPlaces();
  }

  void _navigateToDetails(String placeId) {
    debugPrint('🔍 SwipeScreen: Navegando para detalhes: $placeId');
    AppRoutes.navigateToPlaceDetails(context, placeId);
  }

  void _onNavBarTap(int index) {
    if (index == 2) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.discover);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.map);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }
}
