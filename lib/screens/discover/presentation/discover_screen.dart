// screens/discover/discover_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/screens/home/presentation/providers/home_provider.dart';
import 'package:vivar/widgets/buttons/custom_bottom_nav_bar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/constants/routes.dart';
import 'widgets/discover_card.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _collections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCollections();
    });
  }

  Future<void> _loadCollections() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('🔄 DiscoverScreen: Carregando coleções...');

      // final businessesProvider = context.read<PlacesProvider>();
      final homeProvider = context.read<HomeProvider>();

      // // Carregar lugares se ainda não foram carregados
      // if (homeProvider.businesses.isEmpty) {
      //   await homeProvider._loadPlaces;
      // }

      // Gerar coleções baseadas nos lugares do banco
      _collections = _generateCollections(homeProvider);

      setState(() => _isLoading = false);

      debugPrint('✅ DiscoverScreen: ${_collections.length} coleções geradas');
    } catch (e) {
      debugPrint('❌ DiscoverScreen: Erro ao carregar coleções: $e');
      setState(() => _isLoading = false);
    }
  }

  /// Gera coleções dinamicamente baseadas nos lugares
  List<Map<String, dynamic>> _generateCollections(HomeProvider provider) {
    final businesses = provider.businesses;

    if (businesses.isEmpty) {
      return [];
    }

    // Agrupar lugares por categoria
    final categoryCounts = <String, int>{};
    final categoryImages = <String, String>{};

    for (var place in businesses) {
      categoryCounts[place.category] =
          (categoryCounts[place.category] ?? 0) + 1;

      // Guardar primeira imagem da categoria
      if (!categoryImages.containsKey(place.category) &&
          place.images != null &&
          place.images!.isNotEmpty) {
        categoryImages[place.category] = place.images!.first;
      }
    }

    // Criar coleções
    final collections = <Map<String, dynamic>>[];

    // Coleção "Todos os Lugares"
    collections.add({
      'id': 'all',
      'title': 'Todos os Lugares',
      'category': 'Geral',
      'description': 'Explore todos os lugares cadastrados na plataforma',
      'imageUrl': businesses.first.images?.first ?? 'assets/images/cafe.png',
      'businessesCount': businesses.length,
    });

    // Coleções por categoria
    categoryCounts.forEach((category, count) {
      collections.add({
        'id': 'cat_${category.toLowerCase().replaceAll(' ', '_')}',
        'title': _getCategoryTitle(category),
        'category': category,
        'description': _getCategoryDescription(category),
        'imageUrl': categoryImages[category] ?? 'assets/images/cafe.png',
        'businessesCount': count,
      });
    });

    // Coleções especiais
    final openPlaces = businesses.where((p) => p.isOpen).length;
    if (openPlaces > 0) {
      collections.add({
        'id': 'open_now',
        'title': 'Abertos Agora',
        'category': 'Especial',
        'description': 'Lugares abertos e prontos para receber você',
        'imageUrl':
            businesses.firstWhere((p) => p.isOpen).images?.first ??
            'assets/images/cafe.png',
        'businessesCount': openPlaces,
      });
    }

    final withDiscounts = businesses
        .where((p) => p.discountText != null)
        .length;
    if (withDiscounts > 0) {
      collections.add({
        'id': 'discounts',
        'title': 'Com Desconto',
        'category': 'Promoções',
        'description': 'Aproveite ofertas exclusivas e economize',
        'imageUrl':
            businesses
                .firstWhere((p) => p.discountText != null)
                .images
                ?.first ??
            'assets/images/cafe.png',
        'businessesCount': withDiscounts,
      });
    }

    final premiumPlaces = businesses.where((p) => p.isPremiumOnly).length;
    if (premiumPlaces > 0) {
      collections.add({
        'id': 'premium',
        'title': 'Vivar Plus',
        'category': 'Premium',
        'description': 'Lugares exclusivos para assinantes Vivar Plus',
        'imageUrl':
            businesses.firstWhere((p) => p.isPremiumOnly).images?.first ??
            'assets/images/cafe.png',
        'businessesCount': premiumPlaces,
      });
    }

    // Lugares próximos
    final nearbyPlaces = businesses
        .where((p) => p.distance != null && p.distance! < 1000)
        .length;
    if (nearbyPlaces > 0) {
      collections.add({
        'id': 'nearby',
        'title': 'Pertinho de Você',
        'category': 'Localização',
        'description': 'Lugares a menos de 1km de distância',
        'imageUrl':
            businesses
                .firstWhere((p) => p.distance != null && p.distance! < 1000)
                .images
                ?.first ??
            'assets/images/cafe.png',
        'businessesCount': nearbyPlaces,
      });
    }

    // Bem avaliados
    final topRated = businesses.where((p) => p.rating >= 4.5).length;
    if (topRated > 0) {
      collections.add({
        'id': 'top_rated',
        'title': 'Mais Bem Avaliados',
        'category': 'Qualidade',
        'description': 'Lugares com as melhores avaliações dos usuários',
        'imageUrl':
            businesses.firstWhere((p) => p.rating >= 4.5).images?.first ??
            'assets/images/cafe.png',
        'businessesCount': topRated,
      });
    }

    return collections;
  }

  String _getCategoryTitle(String category) {
    final titles = {
      'Cafés': 'Melhores Cafés',
      'Restaurantes': 'Restaurantes Incríveis',
      'Bares': 'Happy Hour',
      'Lojas': 'Compras e Serviços',
      'Padarias': 'Padarias Artesanais',
      'Sorveterias': 'Sorvetes e Doces',
    };
    return titles[category] ?? category;
  }

  String _getCategoryDescription(String category) {
    final descriptions = {
      'Cafés': 'Descubra os cafés mais aconchegantes da região',
      'Restaurantes': 'Sabores para todos os gostos e ocasiões',
      'Bares': 'Os melhores lugares para curtir com os amigos',
      'Lojas': 'Encontre o que você precisa pertinho de você',
      'Padarias': 'Pães fresquinhos e bolos caseiros',
      'Sorveterias': 'Sorvetes artesanais e sobremesas deliciosas',
    };
    return descriptions[category] ??
        'Explore os melhores lugares desta categoria';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header com gradiente
          _buildHeader(),

          // Conteúdo
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _collections.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadCollections,
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: EdgeInsets.all(AppSpacing.horizontalPadding),
                      itemCount: _collections.length,
                      itemBuilder: (context, index) {
                        final collection = _collections[index];
                        return DiscoverCard(
                          imageUrl: collection['imageUrl'],
                          title: collection['title'],
                          category: collection['category'],
                          description: collection['description'],
                          businessesCount: collection['businessesCount'],
                          onTap: () => _openCollection(collection),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: _onNavBarTap,
      ),
    );
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
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título e ícone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explorar',
                        style: AppTextStyles.h2.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Coleções especiais para você',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.explore, color: Colors.white, size: 24),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Barra de busca
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: AppTextStyles.body.copyWith(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Buscar coleções...',
                          hintStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                        onPressed: _openFilters,
                        padding: EdgeInsets.all(8),
                        constraints: BoxConstraints(),
                      ),
                    ),
                    SizedBox(width: 4),
                  ],
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
            'Carregando coleções...',
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
            Icon(
              Icons.collections_bookmark_outlined,
              size: 80,
              color: AppColors.border,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma coleção disponível',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Cadastre lugares para criar coleções automaticamente',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCollections,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    // TODO: Implementar busca nas coleções
    debugPrint('🔍 Busca: $query');
  }

  void _openCollection(Map<String, dynamic> collection) {
    debugPrint('📂 Abrindo coleção: ${collection['title']}');

    // TODO: Navegar para tela de coleção com filtro aplicado
    final collectionId = collection['id'] as String;

    if (collectionId.startsWith('cat_')) {
      // Filtrar por categoria
      final category = collection['category'] as String;
      Navigator.pushNamed(
        context,
        AppRoutes.home,
        arguments: {'filterCategory': category},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Abrindo: ${collection['title']}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _openFilters() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Filtros em breve')));
  }

  void _onNavBarTap(int index) {
    if (index == 1) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.swipe);
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
