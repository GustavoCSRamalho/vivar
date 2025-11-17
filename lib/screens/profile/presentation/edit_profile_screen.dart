// screens/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/core/constants/spacing.dart';
import 'package:vivar/screens/auth/data/repositories/auth_repository_impl.dart';
import 'package:vivar/screens/profile/presentation/providers/edit_profile_provider.dart';
import 'package:vivar/widgets/buttons/custom_text_field.dart';
import 'package:vivar/widgets/buttons/primary_button.dart';
import 'package:vivar/widgets/inputs/custom_text_field.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  late var userId;

  final List<String> _availableInterests = [
    '☕ Café',
    '🍔 Hambúrguer',
    '🍕 Pizza',
    '🍣 Japonês',
    '🥗 Saudável',
    '🍰 Doces',
    '🍺 Cerveja',
    '🎨 Arte',
    '📚 Livros',
    '🎵 Música',
    '🐕 Pet friendly',
    '🌱 Vegano',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final provider = context.read<EditProfileProvider>();
    final auth = context.read<AuthRepositoryImpl>();
    userId = await auth.getCurrentUserId();
    await provider.loadProfile(userId);

    if (provider.profile != null) {
      final profile = provider.profile!;
      setState(() {
        _nameController.text = profile.name;
        _usernameController.text = profile.username ?? '';
        _bioController.text = profile.bio ?? '';
        _phoneController.text = profile.phone ?? '';
        _locationController.text = profile.location ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Editar Perfil'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<EditProfileProvider>(
            builder: (context, provider, child) {
              return TextButton(
                onPressed: provider.isLoading ? null : _saveProfile,
                child: Text(
                  'Salvar',
                  style: AppTextStyles.body.copyWith(
                    color: provider.isLoading
                        ? AppColors.textSecondary
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EditProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.profile == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.horizontalPadding),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildAvatarSection(provider),
                  SizedBox(height: 40),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nome completo',
                    hintText: 'Seu nome',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Nome de usuário',
                    hintText: 'seunome',
                    prefixIcon: Icons.alternate_email,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Somente letras, números e _',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _bioController,
                    label: 'Bio',
                    hintText: 'Conte um pouco sobre você...',
                    maxLines: 4,
                    maxLength: 150,
                  ),
                  SizedBox(height: 20),
                  _buildEmailField(provider),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Telefone',
                    hintText: '(00) 00000-0000',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _locationController,
                    label: 'Localização',
                    hintText: 'Sua cidade',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  SizedBox(height: 32),
                  _buildInterestsSection(provider),
                  SizedBox(height: 32),
                  _buildPrivacySection(provider),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection(provider) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: provider.profile?.avatarUrl != null
              ? ClipOval(
                  child: Image.network(
                    provider.profile!.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildAvatarPlaceholder();
                    },
                  ),
                )
              : _buildAvatarPlaceholder(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _pickImage(provider),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Center(
      child: Text(
        _nameController.text.isNotEmpty
            ? _nameController.text[0].toUpperCase()
            : 'U',
        style: AppTextStyles.h1.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildEmailField(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.email_outlined, color: AppColors.textSecondary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  provider.profile?.email ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.lock_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Para alterar o email, entre em contato com o suporte',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInterestsSection(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seus interesses', style: AppTextStyles.subtitle),
        SizedBox(height: 8),
        Text(
          'Nos ajude a recomendar lugares',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableInterests.map((interest) {
            final isSelected = provider.selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () => provider.toggleInterest(interest),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  interest,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Privacidade', style: AppTextStyles.subtitle),
        SizedBox(height: 16),
        _buildPrivacySwitch(
          provider,
          'public_profile',
          'Perfil público',
          'Permite que outros usuários vejam seu perfil',
        ),
        SizedBox(height: 12),
        _buildPrivacySwitch(
          provider,
          'show_location',
          'Mostrar localização',
          'Exibe sua cidade no perfil',
        ),
        SizedBox(height: 12),
        _buildPrivacySwitch(
          provider,
          'show_checkins',
          'Mostrar check-ins',
          'Outros podem ver onde você visitou',
        ),
      ],
    );
  }

  Widget _buildPrivacySwitch(
    provider,
    String key,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: provider.privacySettings[key] ?? false,
            onChanged: (value) => provider.updatePrivacySetting(key, value),
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  void _pickImage(provider) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Tirar foto'),
              onTap: () async {
                Navigator.pop(context);
                await _uploadImage(provider, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Escolher da galeria'),
              onTap: () async {
                Navigator.pop(context);
                await _uploadImage(provider, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: AppColors.error),
              title: Text(
                'Remover foto',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _removeAvatar(provider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage(provider, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        final success = await provider.uploadAvatar(userId, image.path);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Avatar atualizado com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _removeAvatar(provider) async {
    final success = await provider.removeAvatar(userId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Avatar removido com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<EditProfileProvider>();
    final success = await provider.updateProfile(
      userId: userId,
      name: _nameController.text,
      username: _usernameController.text.isEmpty
          ? null
          : _usernameController.text,
      bio: _bioController.text.isEmpty ? null : _bioController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      location: _locationController.text.isEmpty
          ? null
          : _locationController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Erro ao atualizar perfil'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
