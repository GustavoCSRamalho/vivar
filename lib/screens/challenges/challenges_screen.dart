// screens/challenges/challenges_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../providers/challenges_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/challenge_model.dart';

class ChallengesScreen extends StatefulWidget {
  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    final user = context.read<UserProvider>().currentUser;
    if (user != null) {
      await context.read<ChallengesProvider>().loadChallenges(user.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Desafios'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Ativos'),
            Tab(text: 'Concluídos'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeroSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildActiveChallenges(), _buildCompletedChallenges()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🏆', style: TextStyle(fontSize: 60)),
            SizedBox(height: 12),
            Text(
              'Complete desafios',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'Ganhe badges e descontos exclusivos',
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveChallenges() {
    return Consumer<ChallengesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final challenges = provider.activeChallenges;

        if (challenges.isEmpty) {
          return _buildEmptyState(
            'Nenhum desafio ativo',
            'Novos desafios em breve!',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadChallenges,
          child: ListView.builder(
            padding: EdgeInsets.all(AppSpacing.horizontalPadding),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              return _buildChallengeCard(challenges[index], isActive: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedChallenges() {
    return Consumer<ChallengesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final challenges = provider.completedChallenges;

        if (challenges.isEmpty) {
          return _buildEmptyState(
            'Nenhum desafio concluído',
            'Complete desafios para desbloquear recompensas!',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSpacing.horizontalPadding),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            return _buildChallengeCard(challenges[index], isActive: false);
          },
        );
      },
    );
  }

  Widget _buildChallengeCard(
    ChallengeModel challenge, {
    required bool isActive,
  }) {
    final progress = challenge.currentCount / challenge.targetCount;
    final gradientColors = _getGradientColors(challenge.challengeType);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isActive ? 'EM ANDAMENTO' : 'CONCLUÍDO',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  _getChallengeIcon(challenge.challengeType),
                  style: TextStyle(fontSize: 32),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge.title, style: AppTextStyles.subtitle),
                SizedBox(height: 4),
                Text(
                  challenge.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                if (isActive) ...[
                  SizedBox(height: 16),
                  Text(
                    '${challenge.currentCount} de ${challenge.targetCount} completo',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],

                SizedBox(height: 20),

                // Recompensas
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (challenge.rewardBadge != null)
                        _buildReward('🏆', 'Badge\nExclusivo'),
                      if (challenge.rewardPoints > 0)
                        _buildReward('⭐', '${challenge.rewardPoints}\nPontos'),
                      if (challenge.rewardDiscount != null)
                        _buildReward('🎟️', challenge.rewardDiscount!),
                    ],
                  ),
                ),

                if (isActive) ...[
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Expira em ${_getDaysLeft(challenge.endDate)} dias',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReward(String emoji, String text) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 32)),
        SizedBox(height: 8),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String description) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎯', style: TextStyle(fontSize: 80)),
            SizedBox(height: 16),
            Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
            SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String type) {
    switch (type) {
      case 'checkin':
        return [Color(0xFFFF6B35), Color(0xFFFFC857)];
      case 'explore':
        return [Color(0xFF004E89), Color(0xFF0077B6)];
      case 'social':
        return [Color(0xFF9333EA), Color(0xFFC084FC)];
      default:
        return [AppColors.primary, AppColors.accent];
    }
  }

  String _getChallengeIcon(String type) {
    switch (type) {
      case 'checkin':
        return '📍';
      case 'explore':
        return '🗺️';
      case 'social':
        return '👥';
      default:
        return '🎯';
    }
  }

  int _getDaysLeft(DateTime endDate) {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Como funcionam os desafios?'),
        content: Text(
          'Complete desafios para ganhar badges exclusivos, pontos extras e descontos especiais. '
          'Quanto mais você explora, mais recompensas você ganha!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
