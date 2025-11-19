// screens/map/map_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/screens/map/presentation/providers/map_provider.dart';

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
      _loadNearbyPlaces();
    });
  }

  Future<void> _loadNearbyPlaces() async {
    final provider = context.read<MapProvider>();
    if (!provider.isDisposed) {
      await provider.loadNearbyPlaces(
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
          left: 16,
          right: 16,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.name, style: AppTextStyles.subtitle),
                            SizedBox(height: 4),
                            Text(
                              place.category,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () {
                          if (!provider.isDisposed) {
                            provider.clearSelection();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (place.description != null &&
                      place.description!.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      place.description!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/place-details',
                              arguments: place.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Ver detalhes'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (!provider.isDisposed) {
                              provider.animateToPlace(place);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Como chegar',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSearch(String query) async {
    final provider = context.read<MapProvider>();
    if (!provider.isDisposed) {
      await provider.searchPlaces(
        query,
        _currentLocation.latitude,
        _currentLocation.longitude,
      );
    }
  }
}
