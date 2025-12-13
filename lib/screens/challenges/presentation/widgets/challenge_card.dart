// widgets/cards/challenge_card.dart

import 'package:flutter/material.dart';
import '../../../../../packages/design_system_module/lib/src/constants/colors.dart';
import '../../../../../packages/design_system_module/lib/src/constants/text_styles.dart';

import '../../../../domain/entity/challenge/challenge_entity.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeEntity challenge;
  final bool isActive;
  final VoidCallback? onTap;

  const ChallengeCard({
    Key? key,
    required this.challenge,
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = challenge.progress;
    final gradientColors = _getGradientColors(challenge.challengeType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [_buildHeader(gradientColors), _buildBody(progress)],
        ),
      ),
    );
  }

  Widget _buildHeader(List<Color> gradientColors) {
    return Container(
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
    );
  }

  Widget _buildBody(double progress) {
    return Padding(
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
          if (isActive) ...[SizedBox(height: 16), _buildProgress(progress)],
          SizedBox(height: 20),
          _buildRewards(),
          if (isActive) ...[SizedBox(height: 20), _buildTimeLeft()],
        ],
      ),
    );
  }

  Widget _buildProgress(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildRewards() {
    return Container(
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

  Widget _buildTimeLeft() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
        SizedBox(width: 4),
        Text(
          'Expira em ${challenge.daysLeft} dias',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
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
}
