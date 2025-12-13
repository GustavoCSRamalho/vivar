// screens/map/map_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../packages/design_system_module/lib/src/constants/colors.dart';
import 'package:vivar/core/constants/routes.dart';
import '../../../../packages/design_system_module/lib/src/constants/text_styles.dart';
import 'package:vivar/screens/map/presentation/providers/map_provider.dart';
import 'package:vivar/screens/map/presentation/widgets/place_preview_card.dart';

import '../../../factory/map_provider_factory.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapProviderFactory.create(),
      child: _MapScreenContent(),
    );
  }
}

class _MapScreenContent extends StatefulWidget {
  @override
  _MapScreenContentState createState() => _MapScreenContentState();
}

class _MapScreenContentState extends State<_MapScreenContent> {
  final TextEditingController _searchController = TextEditingController();

  // Localização padrão (São Paulo)
  static const LatLng _defaultLocation = LatLng(-23.5505, -46.6333);
  LatLng _currentLocation = _defaultLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNearbyBusinesses();
    });
  }

  Future<void> _loadNearbyBusinesses() async {
    final provider = context.read<MapProvider>();
    if (!provider.isDisposed) {
      await provider.loadNearbyBusinesses(
        _currentLocation.latitude,
        _currentLocation.longitude,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    debugPrint('🗑️ MapScreen dispose chamado');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildMap(), _buildSearchBar(), _buildSelectedPlaceCard()],
      ),
    );
  }

  Widget _buildMap() {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            if (!provider.isDisposed) {
              provider.onMapCreated(controller);
            }
          },
          markers: provider.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onCameraMove: (position) {
            _currentLocation = position.target;
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar lugares...',
                        border: InputBorder.none,
                        hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onSubmitted: _onSearch,
                    ),
                  ),
                  Consumer<MapProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      return IconButton(
                        icon: Icon(Icons.search, color: AppColors.primary),
                        onPressed: () => _onSearch(_searchController.text),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPlaceCard() {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        final place = provider.selectedPlace;
        if (place == null) return SizedBox.shrink();

        return Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: PlacePreviewCard(
            place: place,
            onTap: () {
              AppRoutes.navigateToBusinessesDetails(context, place.id);
            },
          ),
        );
      },
    );
  }

  Future<void> _onSearch(String query) async {
    final provider = context.read<MapProvider>();
    if (!provider.isDisposed) {
      await provider.searchBusinesses(
        query,
        _currentLocation.latitude,
        _currentLocation.longitude,
      );
    }
  }
}
