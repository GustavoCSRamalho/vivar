// screens/merchant/merchant_register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/core/constants/spacing.dart';
import 'package:vivar/screens/merchant/presentation/providers/merchant_register_provider.dart';
import 'package:vivar/widgets/buttons/custom_text_field.dart';
import 'package:vivar/widgets/buttons/primary_button.dart';
import 'package:vivar/widgets/inputs/custom_text_field.dart';
import 'dart:io';

class MerchantRegisterScreen extends StatefulWidget {
  @override
  _MerchantRegisterScreenState createState() => _MerchantRegisterScreenState();
}

class _MerchantRegisterScreenState extends State<MerchantRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Café',
    'Restaurante',
    'Bar',
    'Padaria',
    'Sorveteria',
    'Loja',
    'Serviço',
    'Outro',
  ];

  final List<String> _amenities = [
    'Wi-Fi grátis',
    'Estacionamento',
    'Acessível',
    'Pet friendly',
    'Aceita cartão',
    'Delivery',
    'Ambiente externo',
    'Ar condicionado',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MerchantRegisterProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
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
            child: SafeArea(bottom: false, child: _buildHeader()),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    _buildSectionTitle('Informações básicas'),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nome do estabelecimento',
                      hintText: 'Ex: Café das Flores',
                      prefixIcon: Icons.store,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      label: 'Endereço completo',
                      hintText: 'Rua, número, bairro',
                      prefixIcon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Endereço é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _useCurrentLocation,
                      icon: Icon(Icons.my_location, size: 18),
                      label: Text('Usar minha localização'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Telefone/WhatsApp',
                      hintText: '(00) 00000-0000',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telefone é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Consumer<MerchantRegisterProvider>(
                      builder: (context, provider, child) {
                        return CheckboxListTile(
                          title: Text(
                            'Este número é WhatsApp',
                            style: AppTextStyles.bodySmall,
                          ),
                          value: provider.isWhatsapp,
                          onChanged: (value) =>
                              provider.setWhatsapp(value ?? true),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.success,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email do estabelecimento',
                      hintText: 'contato@estabelecimento.com',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email é obrigatório';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Descrição',
                      hintText: 'Conte sobre seu estabelecimento...',
                      maxLines: 4,
                      maxLength: 300,
                    ),
                    SizedBox(height: 32),
                    _buildSectionTitle('Fotos do estabelecimento'),
                    SizedBox(height: 8),
                    Text(
                      'Adicione até 5 fotos (mínimo 1)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildPhotoGrid(),
                    SizedBox(height: 32),
                    _buildSectionTitle('Horário de funcionamento'),
                    SizedBox(height: 16),
                    _buildScheduleSection(),
                    SizedBox(height: 32),
                    _buildSectionTitle('Comodidades'),
                    SizedBox(height: 16),
                    _buildAmenitiesGrid(),
                    SizedBox(height: 32),
                    _buildTermsCheckbox(),
                    SizedBox(height: 24),
                    Consumer<MerchantRegisterProvider>(
                      builder: (context, provider, child) {
                        return PrimaryButton(
                          text: 'Cadastrar estabelecimento',
                          onPressed: provider.canSubmit
                              ? () => _submitForm()
                              : () => (),
                          isLoading: provider.isLoading,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: 'Precisa de ajuda? '),
                            TextSpan(
                              text: 'Fale conosco',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          Icon(Icons.store, size: 64, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Aumente suas vendas',
            style: AppTextStyles.h2.copyWith(color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            'Cadastre seu estabelecimento gratuitamente',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.h3);
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text('Selecione uma categoria'),
              value: _categoryController.text.isEmpty
                  ? null
                  : _categoryController.text,
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() => _categoryController.text = value ?? '');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    return Consumer<MerchantRegisterProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            if (index < provider.selectedImages.length) {
              return _buildPhotoItem(provider.selectedImages[index], provider);
            } else {
              return _buildPhotoPlaceholder();
            }
          },
        );
      },
    );
  }

  Widget _buildPhotoItem(String imagePath, provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => provider.removeImage(imagePath),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          border: Border.all(color: AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              color: AppColors.textSecondary,
              size: 32,
            ),
            SizedBox(height: 4),
            Text(
              'Adicionar',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Consumer<MerchantRegisterProvider>(
      builder: (context, provider, child) {
        return Column(
          children: provider.schedule.keys.map((day) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      day,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => _editSchedule(day, provider),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.schedule[day] ?? '',
                              style: AppTextStyles.bodySmall,
                            ),
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAmenitiesGrid() {
    return Consumer<MerchantRegisterProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _amenities.length,
          itemBuilder: (context, index) {
            final amenity = _amenities[index];
            final isSelected = provider.selectedAmenities.contains(amenity);

            return GestureDetector(
              onTap: () => provider.toggleAmenity(amenity),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        amenity,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Consumer<MerchantRegisterProvider>(
      builder: (context, provider, child) {
        return CheckboxListTile(
          title: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: 'Li e aceito os '),
                TextSpan(
                  text: 'Termos de Uso',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' e '),
                TextSpan(
                  text: 'Política de Privacidade',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' para comerciantes'),
              ],
            ),
          ),
          value: provider.acceptTerms,
          onChanged: (value) => provider.setAcceptTerms(value ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.primary,
        );
      },
    );
  }

  void _useCurrentLocation() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Obtendo localização...')));
  }

  Future<void> _pickImage() async {
    final provider = context.read<MerchantRegisterProvider>();

    if (provider.selectedImages.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Máximo de 5 fotos')));
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        provider.addImage(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao selecionar imagem: $e')));
    }
  }

  void _editSchedule(String day, provider) {
    final controller = TextEditingController(text: provider.schedule[day]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Horário - $day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Horário',
                hintText: '08:00 - 18:00',
              ),
              controller: controller,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      provider.updateSchedule(day, 'Fechado');
                      Navigator.pop(context);
                    },
                    child: Text('Fechado'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      provider.updateSchedule(day, '24 horas');
                      Navigator.pop(context);
                    },
                    child: Text('24h'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.updateSchedule(day, controller.text);
              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<MerchantRegisterProvider>();
    final success = await provider.registerMerchant(
      name: _nameController.text,
      category: _categoryController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      description: _descriptionController.text,
    );

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 32),
              SizedBox(width: 12),
              Text('Sucesso!'),
            ],
          ),
          content: Text(
            'Seu estabelecimento foi cadastrado com sucesso! '
            'Em breve nossa equipe entrará em contato para validação.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Erro ao cadastrar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
