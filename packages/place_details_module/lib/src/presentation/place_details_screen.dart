// screens/place_details/place_details_screen.dart
import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:place_details_module/src/domain/entity/business_entity.dart';
import 'package:provider/provider.dart';
import 'providers/place_details_provider.dart';

class BusinessesDetailsScreen extends StatefulWidget {
  final String businessesId;

  const BusinessesDetailsScreen({Key? key, required this.businessesId})
    : super(key: key);

  @override
  _BusinessesDetailsScreenState createState() =>
      _BusinessesDetailsScreenState();
}

class _BusinessesDetailsScreenState extends State<BusinessesDetailsScreen> {
  final PageController _photoController = PageController();
  final ValueNotifier<bool> _showBottomBar = ValueNotifier(false);
  int _currentPhotoIndex = 0;
  bool _isFavorite = false;
  BusinessEntity? _place;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '🏗️ PlaceDetailsScreen initState com ID: ${widget.businessesId}',
    );
    // NÃO chamar _loadPlace() aqui
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Chamar aqui, quando o context está disponível
    if (_isLoading && _place == null) {
      _loadPlace();
    }
  }

  Future<void> _loadPlace() async {
    debugPrint('📥 Carregando lugar: ${widget.businessesId}');

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final businessesProvider = context.read<PlaceDetailsProvider>();
      final homeProvider = context.read<HomeProvider>();

      // Buscar o lugar pelo ID
      await businessesProvider.getPlaceById(widget.businessesId);

      final place = businessesProvider.place!;

      debugPrint('🔍 Lugar encontrado: ${place?.name}');

      if (place != null) {
        final isFav = homeProvider.isFavorite(widget.businessesId);

        setState(() {
          _place = place;
          _isFavorite = isFav;
          _isLoading = false;
        });

        debugPrint('✅ Lugar carregado com sucesso: ${place.name}');
      } else {
        debugPrint('❌ Lugar não encontrado no banco');
        setState(() {
          _error = 'Lugar não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar lugar: $e');
      setState(() {
        _error = 'Erro ao carregar detalhes';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '🎨 PlaceDetailsScreen build - isLoading: $_isLoading, place: ${_place?.name}, image: ${_place?.images}',
    );

    // Loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('Carregando...', style: AppTextStyles.body),
            ],
          ),
        ),
      );
    }

    // Error state
    if (_error != null || _place == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                SizedBox(height: 16),
                Text(
                  _error ?? 'Lugar não encontrado',
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                PrimaryButton(
                  text: 'Voltar',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Success state - Tela normal
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // controla a posição do scroll para detectar se está no fim
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 50) {
            _showBottomBar.value = true;
          } else {
            _showBottomBar.value = false;
          }
          return true;
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header com imagem
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.white,
                  leading: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.share, color: AppColors.textPrimary),
                        onPressed: _share,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildImageGallery(),
                  ),
                ),

                // Conteúdo
                SliverToBoxAdapter(
                  child: Container(
                    transform: Matrix4.translationValues(0, -24, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          _buildPlaceInfo(),
                          SizedBox(height: 24),
                          _buildDescription(),
                          SizedBox(height: 24),
                          _buildAmenities(),
                          SizedBox(height: 24),
                          _buildLocation(),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom bar que aparece só no final
            ValueListenableBuilder<bool>(
              valueListenable: _showBottomBar,
              builder: (context, visible, child) {
                return AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  left: 0,
                  right: 0,
                  bottom: visible ? 0 : -200,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: Duration(milliseconds: 250),
                    child: _buildBottomBar(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = _place?.images ?? [];

    if (images.isEmpty) {
      return Container(
        color: AppColors.border,
        child: Center(
          child: Icon(Icons.image, size: 64, color: AppColors.textSecondary),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _photoController,
          onPageChanged: (index) => setState(() => _currentPhotoIndex = index),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.asset(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.border,
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            );
          },
        ),

        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPhotoIndex + 1} / ${images.length}',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_place!.name, style: AppTextStyles.h2),
        SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < _place!.rating.floor()
                    ? Icons.star
                    : (index < _place!.rating
                          ? Icons.star_half
                          : Icons.star_border),
                color: AppColors.accent,
                size: 20,
              );
            }),
            SizedBox(width: 8),
            Text('${_place!.rating}', style: AppTextStyles.subtitle),
            SizedBox(width: 4),
            Text(
              '(${_place!.reviewsCount} avaliações)',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              _place!.category,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_place!.priceRange != null) ...[
              SizedBox(width: 8),
              Text(
                '· ${_place!.priceRange}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _place!.isOpen ? Color(0xFFECFDF5) : Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                color: _place!.isOpen ? Color(0xFF059669) : AppColors.error,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                _place!.isOpen ? 'Aberto agora' : 'Fechado',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _place!.isOpen ? Color(0xFF059669) : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (_place!.discountText != null) ...[
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_offer, color: AppColors.primary, size: 16),
                SizedBox(width: 8),
                Text(
                  _place!.discountText!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDescription() {
    if (_place!.description == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sobre', style: AppTextStyles.h3),
        SizedBox(height: 8),
        Text(
          _place!.description!,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    if (_place!.amenities == null || _place!.amenities!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comodidades', style: AppTextStyles.h3),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _place!.amenities!.map((amenity) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                amenity,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Localização', style: AppTextStyles.h3),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_place!.address}, ${_place!.city} - ${_place!.state}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        if (_place!.distance != null) ...[
          SizedBox(height: 4),
          Text(
            '${(_place!.distance! / 1000).toStringAsFixed(1)} km de você',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: 'Como chegar',
                icon: Icons.directions,
                onPressed: _openDirections,
                height: 52,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                text: 'Check-in',
                icon: Icons.location_on,
                onPressed: _doCheckIn,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _share() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Compartilhamento em breve')));
  }

  void _toggleFavorite() async {
    final user = await context.read<LoginProvider>().currentUser;
    if (user != null) {
      await context.read<HomeProvider>().toggleFavorite(widget.businessesId);
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  void _openDirections() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Abrir mapa em breve')));
  }

  void _doCheckIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Check-in será implementado em breve')),
    );
  }

  @override
  void dispose() {
    _photoController.dispose();
    super.dispose();
  }
}
