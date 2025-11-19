// widgets/modals/filters_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/screens/home/presentation/providers/home_provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../providers/places_provider.dart';

class FiltersBottomSheet extends StatefulWidget {
  @override
  _FiltersBottomSheetState createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  double _distance = 5.0;
  List<String> _selectedCategories = [];
  String? _selectedPriceRange;
  double? _minRating;
  List<String> _selectedAmenities = [];
  bool _openNow = false;

  final List<String> _categories = [
    'Cafés',
    'Restaurantes',
    'Bares',
    'Padarias',
    'Sorveterias',
    'Lojas',
    'Serviços',
    'Eventos',
  ];

  final List<String> _amenities = [
    'Wi-Fi grátis',
    'Estacionamento',
    'Acessível',
    'Pet friendly',
    'Aceita cartão',
    'Delivery',
    'Ambiente externo',
    'Música ao vivo',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSpacing.horizontalPadding),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Limpar',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text('Filtros', style: AppTextStyles.subtitle),
                TextButton(
                  onPressed: _applyFilters,
                  child: Text(
                    'Aplicar',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.horizontalPadding),
              children: [
                SizedBox(height: 20),

                // Distância
                _buildSection(
                  'Distância',
                  Column(
                    children: [
                      Slider(
                        value: _distance,
                        min: 1,
                        max: 20,
                        divisions: 19,
                        label: 'Até ${_distance.toStringAsFixed(0)} km',
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() => _distance = value);
                        },
                      ),
                      Text(
                        'Até ${_distance.toStringAsFixed(0)} km',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Categorias
                _buildSection(
                  'Categorias',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedCategories.remove(category);
                            } else {
                              _selectedCategories.add(category);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 32),

                // Preço
                _buildSection(
                  'Faixa de preço',
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['\$', '\$\$', '\$\$\$', '\$\$\$\$'].map((price) {
                      final isSelected = _selectedPriceRange == price;
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () =>
                                _selectedPriceRange = isSelected ? null : price,
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              price,
                              style: AppTextStyles.h3.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 32),

                // Comodidades
                _buildSection(
                  'Comodidades',
                  Column(
                    children: _amenities.map((amenity) {
                      final isSelected = _selectedAmenities.contains(amenity);
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          title: Text(amenity, style: AppTextStyles.body),
                          value: isSelected,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 32),

                // Avaliação
                _buildSection(
                  'Avaliação mínima',
                  Column(
                    children: [5.0, 4.0, 3.0].map((rating) {
                      final isSelected = _minRating == rating;
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () => _minRating = isSelected ? null : rating,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFFFF4E6)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ...List.generate(
                                rating.toInt(),
                                (index) => Icon(
                                  Icons.star,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${rating.toStringAsFixed(1)} & acima',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 32),

                // Status
                _buildSection(
                  'Disponibilidade',
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: Text('Aberto agora', style: AppTextStyles.body),
                      value: _openNow,
                      activeColor: AppColors.success,
                      onChanged: (value) {
                        setState(() => _openNow = value);
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.subtitle),
        SizedBox(height: 16),
        content,
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _distance = 5.0;
      _selectedCategories.clear();
      _selectedPriceRange = null;
      _minRating = null;
      _selectedAmenities.clear();
      _openNow = false;
    });
  }

  void _applyFilters() {
    context.read<HomeProvider>().applyAdvancedFilters(
      categories: _selectedCategories.isNotEmpty ? _selectedCategories : null,
      priceRange: _selectedPriceRange,
      minRating: _minRating,
      amenities: _selectedAmenities.isNotEmpty ? _selectedAmenities : null,
      openNow: _openNow ? true : null,
    );
    Navigator.pop(context);
  }
}
