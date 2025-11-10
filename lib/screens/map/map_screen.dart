// screens/map/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivar/models/filters_bottom_sheet.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/routes.dart';
import '../../widgets/buttons/custom_bottom_nav_bar.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  PlacePreview? _selectedPlace;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Todos',
    'Cafés',
    'Restaurantes',
    'Bares',
    'Lojas',
  ];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-23.5505, -46.6333), // São Paulo
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    // Adicionar marcadores de exemplo
    setState(() {
      _markers.addAll([
        Marker(
          markerId: MarkerId('place_1'),
          position: LatLng(-23.5505, -46.6333),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          onTap: () => _onMarkerTapped(
            'place_1',
            'Café Raiz',
            'Café',
            '850m',
            4.9,
            '15% OFF',
            true,
          ),
        ),
        Marker(
          markerId: MarkerId('place_2'),
          position: LatLng(-23.5515, -46.6343),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          onTap: () => _onMarkerTapped(
            'place_2',
            'Restaurante Bella',
            'Restaurante',
            '1.2km',
            4.7,
            '20% OFF',
            true,
          ),
        ),
        Marker(
          markerId: MarkerId('place_3'),
          position: LatLng(-23.5495, -46.6323),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          onTap: () => _onMarkerTapped(
            'place_3',
            'Bar do João',
            'Bar',
            '650m',
            4.5,
            '10% OFF',
            false,
          ),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: (_) {
              // Fechar preview ao tocar no mapa
              if (_selectedPlace != null) {
                setState(() => _selectedPlace = null);
              }
            },
          ),

          // Search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 76,
            child: _buildSearchBar(),
          ),

          // Botão recentralizar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: _buildRecenterButton(),
          ),

          // Filtros de categoria
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 0,
            right: 0,
            child: _buildCategoryFilters(),
          ),

          // Card de preview
          if (_selectedPlace != null)
            Positioned(
              bottom: 80, // Espaço para o bottom nav bar
              left: 0,
              right: 0,
              child: _buildPreviewCard(),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Icon(Icons.search, color: AppColors.textSecondary),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar no mapa...',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                // TODO: Implementar busca
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune, color: AppColors.textSecondary),
            onPressed: _openFilters,
          ),
        ],
      ),
    );
  }

  Widget _buildRecenterButton() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.my_location, color: AppColors.primary),
        onPressed: _recenterMap,
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategoryIndex = index);
                _filterMarkers(index);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _categories[index],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewCard() {
    final place = _selectedPlace!;

    return GestureDetector(
      onTap: () => _navigateToDetails(place.id),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.border,
                child: Icon(
                  Icons.image,
                  color: AppColors.textSecondary,
                  size: 32,
                ),
              ),
            ),

            SizedBox(width: 16),

            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.accent, size: 16),
                          SizedBox(width: 4),
                          Text(
                            place.rating.toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${place.category} · ${place.distance}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF4E6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place.discount,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: place.isOpen
                              ? Color(0xFFECFDF5)
                              : Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place.isOpen ? 'Aberto' : 'Fechado',
                          style: AppTextStyles.caption.copyWith(
                            color: place.isOpen
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Botão seta
            Icon(Icons.chevron_right, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }

  void _onMarkerTapped(
    String placeId,
    String name,
    String category,
    String distance,
    double rating,
    String discount,
    bool isOpen,
  ) {
    setState(() {
      _selectedPlace = PlacePreview(
        id: placeId,
        name: name,
        category: category,
        distance: distance,
        rating: rating,
        discount: discount,
        isOpen: isOpen,
      );
    });
  }

  void _recenterMap() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(_initialPosition),
    );
  }

  void _filterMarkers(int index) {
    // TODO: Implementar filtro de marcadores
    if (index == 0) {
      // Mostrar todos
      _loadMarkers();
    } else {
      // Filtrar por categoria
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Filtrando: ${_categories[index]}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FiltersBottomSheet(),
    );
  }

  void _navigateToDetails(String placeId) {
    AppRoutes.navigateToPlaceDetails(context, placeId);
  }

  void _onNavBarTap(int index) {
    if (index == 3) return; // Já está no Map

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.discover);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.swipe);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// Classe auxiliar
class PlacePreview {
  final String id;
  final String name;
  final String category;
  final String distance;
  final double rating;
  final String discount;
  final bool isOpen;

  PlacePreview({
    required this.id,
    required this.name,
    required this.category,
    required this.distance,
    required this.rating,
    required this.discount,
    required this.isOpen,
  });
}
