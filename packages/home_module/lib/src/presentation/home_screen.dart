// screens/home/home_screen.dart
import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:home_module/src/domain/entity/business_entity.dart';
import 'package:home_module/src/presentation/widgets/filters_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/category_bar.dart';
import 'widgets/today_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    await context.read<HomeProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return HomeHeader(
                location: provider.userLocation,
                onLocationTap: _openLocationPicker,
                onNotificationTap: _openNotifications,
                onSearchTap: _openSearch,
                onFilterTap: _openFilters,
                hasUnreadNotifications: provider.hasUnreadNotifications,
              );
            },
          ),

          // Categorias
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              final selectedIndex = _categories.indexOf(
                provider.selectedCategory,
              );
              return CategoryBar(
                categories: _categories,
                selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
                onCategorySelected: (index) {
                  provider.filterByCategory(_categories[index]);
                },
              );
            },
          ),

          // Feed
          Expanded(
            child: Consumer<HomeProvider>(
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
                List<BusinessEntity> businessesToShow = provider.businesses;

                // Empty state
                if (businessesToShow.isEmpty) {
                  return _buildEmptyState(provider);
                }

                // Success state - Lista de lugares
                return RefreshIndicator(
                  onRefresh: provider.refresh,
                  color: AppColors.primary,
                  child: CustomScrollView(
                    slivers: [
                      // Today Card
                      SliverPadding(
                        padding: EdgeInsets.only(top: 8),
                        sliver: SliverToBoxAdapter(
                          child: TodayCard(
                            title:
                                '${businessesToShow.length} lugares encontrados',
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
                          final Businesses = businessesToShow[index];
                          return BusinessesCard(
                            imageUrl: Businesses.firstImage ?? '',
                            name: Businesses.name,
                            rating: Businesses.rating,
                            category: Businesses.categoryWithPrice,
                            distance: Businesses.formattedDistance,
                            discount: Businesses.discountText,
                            isOpen: Businesses.isOpen,
                            closingTime: '22h',
                            isFavorite: provider.isFavorite(Businesses.id),
                            onTap: () {
                              debugPrint(
                                '🖱️ Card clicado: ${Businesses.name} (${Businesses.id})',
                              );
                              _navigateToDetails(Businesses.id);
                            },
                          );
                        }, childCount: businessesToShow.length),
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

  Widget _buildEmptyState(HomeProvider provider) {
    final isFiltered = provider.selectedCategory != 'Todos';

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
                  provider.clearFilter();
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
    Navigator.pushNamed(context, RouteConstants.notifications);
  }

  void _openSearch() {
    showSearch(context: context, delegate: BusinessesSearchDelegate());
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

  void _navigateToDetails(String BusinessesId) {
    debugPrint('🔍 Navegando para detalhes: $BusinessesId');
    NavigationHelpers.navigateToBusinessesDetails(context, BusinessesId);
  }

  void _onNavBarTap(int index) {
    if (index == 0) return; // Já está na Home

    switch (index) {
      case 1:
        Navigator.pushNamed(context, RouteConstants.discover);
        break;
      case 2:
        Navigator.pushNamed(context, RouteConstants.swipe);
        break;
      case 3:
        Navigator.pushNamed(context, RouteConstants.map);
        break;
      case 4:
        Navigator.pushNamed(context, RouteConstants.profile);
        break;
    }
  }
}

// Search Delegate
class BusinessesSearchDelegate extends SearchDelegate<String> {
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

    context.read<HomeProvider>().searchBusinesses(query);

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (provider.businesses.isEmpty) {
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
          itemCount: provider.businesses.length,
          itemBuilder: (context, index) {
            final Businesses = provider.businesses[index];
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
              title: Text(Businesses.name),
              subtitle: Text(
                '${Businesses.categoryWithPrice} · ${Businesses.formattedDistance}',
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                close(context, Businesses.id);
                NavigationHelpers.navigateToBusinessesDetails(
                  context,
                  Businesses.id,
                );
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
