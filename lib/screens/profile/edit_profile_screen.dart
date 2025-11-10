// screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/widgets/buttons/custom_text_field.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../providers/user_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/custom_text_field.dart';

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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;

    _nameController = TextEditingController(text: user?.name ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
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
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Salvar',
              style: AppTextStyles.body.copyWith(
                color: _isLoading ? AppColors.textSecondary : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.horizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),

              // Avatar
              _buildAvatarSection(),

              SizedBox(height: 40),

              // Nome
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

              // Username
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

              // Bio
              CustomTextField(
                controller: _bioController,
                label: 'Bio',
                hintText: 'Conte um pouco sobre você...',
                maxLines: 4,
                maxLength: 150,
              ),

              SizedBox(height: 20),

              // Email (não editável)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
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
                        Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            context.watch<UserProvider>().currentUser?.email ??
                                '',
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
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Telefone
              CustomTextField(
                controller: _phoneController,
                label: 'Telefone',
                hintText: '(00) 00000-0000',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20),

              // Localização
              CustomTextField(
                controller: _locationController,
                label: 'Localização',
                hintText: 'Sua cidade',
                prefixIcon: Icons.location_on_outlined,
              ),

              SizedBox(height: 32),

              // Seção Interesses
              _buildInterestsSection(),

              SizedBox(height: 32),

              // Seção Privacidade
              _buildPrivacySection(),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
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
          child: Center(
            child: Text(
              _nameController.text.isNotEmpty
                  ? _nameController.text[0].toUpperCase()
                  : 'U',
              style: AppTextStyles.h1.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
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

  Widget _buildInterestsSection() {
    final interests = [
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
          children: interests.map((interest) {
            return _buildInterestChip(interest);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String label) {
    // TODO: Implementar estado selecionado
    final isSelected = false;

    return GestureDetector(
      onTap: () {
        // Toggle seleção
        setState(() {});
      },
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
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Privacidade', style: AppTextStyles.subtitle),
        SizedBox(height: 16),
        _buildPrivacySwitch(
          'Perfil público',
          'Permite que outros usuários vejam seu perfil',
          true,
        ),
        SizedBox(height: 12),
        _buildPrivacySwitch(
          'Mostrar localização',
          'Exibe sua cidade no perfil',
          true,
        ),
        SizedBox(height: 12),
        _buildPrivacySwitch(
          'Mostrar check-ins',
          'Outros podem ver onde você visitou',
          false,
        ),
      ],
    );
  }

  Widget _buildPrivacySwitch(String title, String subtitle, bool value) {
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
            value: value,
            onChanged: (newValue) {
              setState(() {});
            },
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    // TODO: Implementar seleção de imagem
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Tirar foto'),
              onTap: () {
                Navigator.pop(context);
                // Implementar câmera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Escolher da galeria'),
              onTap: () {
                Navigator.pop(context);
                // Implementar galeria
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: AppColors.error),
              title: Text(
                'Remover foto',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implementar remoção
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<UserProvider>().updateProfile(
        name: _nameController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        phone: _phoneController.text,
        location: _locationController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar perfil: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
