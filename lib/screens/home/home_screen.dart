// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/models/filters_bottom_sheet.dart';
import 'package:vivar/widgets/buttons/custom_bottom_nav_bar.dart';
import 'package:vivar/widgets/buttons/place_card.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/routes.dart';
import '../../providers/places_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../core/services/location_service.dart';
import '../../models/place_model.dart';
import 'widgets/home_header.dart';
import 'widgets/category_bar.dart';
import 'widgets/today_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Todos',
    'Cafés',
    'Restaurantes',
    'Bares',
    'Lojas',
    'Eventos',
    'Serviços',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    debugPrint('🔄 Iniciando carregamento de dados...');

    final placesProvider = context.read<PlacesProvider>();
    final userProvider = context.read<UserProvider>();
    final notificationsProvider = context.read<NotificationsProvider>();

    try {
      // 1. Carregar usuário
      await userProvider.loadCurrentUser();
      debugPrint('✅ Usuário carregado');

      // 2. Tentar obter localização
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();

      if (position != null) {
        debugPrint(
          '📍 Localização obtida: ${position.latitude}, ${position.longitude}',
        );

        // Carregar lugares próximos
        // await placesProvider.loadNearbyPlaces(
        //   position.latitude,
        //   position.longitude,
        //   radiusKm: 5.0,
        // );
        await placesProvider.loadPlaces();
        debugPrint('⚠️ placesProvider.loadNearbyPlaces');
      } else {
        debugPrint(
          '⚠️ Localização não disponível, carregando todos os lugares',
        );
        // Sem localização, carregar todos os lugares
        debugPrint('⚠️ placesProvider.loadPlaces');
        await placesProvider.loadPlaces();
      }

      // 3. Carregar favoritos se houver usuário
      if (userProvider.currentUser != null) {
        await placesProvider.loadFavorites(userProvider.currentUser!.id);
        await notificationsProvider.loadNotifications(
          userProvider.currentUser!.id,
        );
      }

      debugPrint('✅ Dados carregados com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao carregar dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Consumer2<UserProvider, NotificationsProvider>(
            builder: (context, userProvider, notificationsProvider, child) {
              return HomeHeader(
                location: userProvider.currentUser?.location ?? 'São Paulo, SP',
                onLocationTap: _openLocationPicker,
                onNotificationTap: _openNotifications,
                onSearchTap: _openSearch,
                onFilterTap: _openFilters,
                hasUnreadNotifications: notificationsProvider.hasUnread,
              );
            },
          ),

          // Categorias
          CategoryBar(
            categories: _categories,
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() => _selectedCategoryIndex = index);
              _filterByCategory(index);
            },
          ),

          // Feed
          Expanded(
            child: Consumer<PlacesProvider>(
              builder: (context, provider, child) {
                // Loading state
                if (provider.isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 16),
                        Text(
                          'Carregando lugares...',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                // Error state
                if (provider.error != null) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Erro ao carregar lugares',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            provider.error!,
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadData,
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

                // Filtrar por categoria se necessário
                List<PlaceModel> placesToShow = provider.places;

                if (_selectedCategoryIndex > 0) {
                  final category = _categories[_selectedCategoryIndex];
                  placesToShow = provider.places
                      .where((place) => place.category == category)
                      .toList();
                  debugPrint(
                    '🔍 Filtrando por $category: ${placesToShow.length} lugares',
                  );
                }

                // Empty state
                if (placesToShow.isEmpty) {
                  return _buildEmptyState();
                }

                // Success state - Lista de lugares
                return RefreshIndicator(
                  onRefresh: _loadData,
                  color: AppColors.primary,
                  child: CustomScrollView(
                    slivers: [
                      // Today Card
                      SliverPadding(
                        padding: EdgeInsets.only(top: 8),
                        sliver: SliverToBoxAdapter(
                          child: TodayCard(
                            title: '${placesToShow.length} lugares encontrados',
                            subtitle: 'Descubra novos lugares perto de você',
                            emoji: '🎉',
                            onTap: _openEvents,
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // Lista de lugares
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final place = placesToShow[index];
                          return PlaceCard(
                            imageUrl: place.images?.isNotEmpty == true
                                ? place.images!.first
                                : '',
                            name: place.name,
                            rating: place.rating,
                            category:
                                '${place.category}${place.priceRange != null ? " · ${place.priceRange}" : ""}',
                            distance: place.distance != null
                                ? '${(place.distance! / 1000).toStringAsFixed(1)}km'
                                : 'N/A',
                            discount: place.discountText,
                            isOpen: place.isOpen,
                            closingTime: '22h',
                            isFavorite: provider.isFavorite(place.id),
                            onTap: () {
                              debugPrint(
                                '🖱️ Card clicado: ${place.name} (${place.id})',
                              );
                              _navigateToDetails(place.id);
                            },
                          );
                        }, childCount: placesToShow.length),
                      ),

                      // Espaço final
                      SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) => _onNavBarTap(index),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFiltered = _selectedCategoryIndex > 0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltered
                  ? Icons.filter_alt_off
                  : Icons.store_mall_directory_outlined,
              size: 80,
              color: AppColors.border,
            ),
            SizedBox(height: 16),
            Text(
              isFiltered
                  ? 'Nenhum lugar nesta categoria'
                  : 'Nenhum lugar encontrado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Tente selecionar outra categoria'
                  : 'Verifique sua conexão e tente novamente',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (isFiltered) {
                  setState(() => _selectedCategoryIndex = 0);
                } else {
                  _loadData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(isFiltered ? 'Ver todos' : 'Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  void _filterByCategory(int index) {
    debugPrint(
      '🔍 Categoria selecionada: ${_categories[index]} (index: $index)',
    );
    setState(() {}); // Força rebuild para aplicar filtro
  }

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.my_location, color: AppColors.primary),
              title: Text('Usar localização atual'),
              onTap: () {
                Navigator.pop(context);
                _loadData();
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: AppColors.primary),
              title: Text('Buscar outra localização'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Busca de localização em breve')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openNotifications() {
    Navigator.pushNamed(context, AppRoutes.notifications);
  }

  void _openSearch() {
    showSearch(context: context, delegate: PlaceSearchDelegate());
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FiltersBottomSheet(),
    );
  }

  void _openEvents() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Eventos em breve')));
  }

  void _navigateToDetails(String placeId) {
    debugPrint('🔍 Navegando para detalhes: $placeId');
    AppRoutes.navigateToPlaceDetails(context, placeId);
  }

  void _onNavBarTap(int index) {
    if (index == 0) return; // Já está na Home

    switch (index) {
      case 1:
        Navigator.pushNamed(context, AppRoutes.discover);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.swipe);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.map);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }
}

// Search Delegate
class PlaceSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Digite para buscar lugares'));
    }

    context.read<PlacesProvider>().searchPlaces(query);

    return Consumer<PlacesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (provider.places.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: AppColors.border),
                SizedBox(height: 16),
                Text(
                  'Nenhum resultado para "$query"',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: provider.places.length,
          itemBuilder: (context, index) {
            final place = provider.places[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.place, color: AppColors.primary),
              ),
              title: Text(place.name),
              subtitle: Text(
                '${place.category}${place.distance != null ? " · ${(place.distance! / 1000).toStringAsFixed(1)}km" : ""}',
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                close(context, place.id);
                AppRoutes.navigateToPlaceDetails(context, place.id);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.border),
            SizedBox(height: 16),
            Text(
              'Digite para buscar lugares',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return buildResults(context);
  }
}
