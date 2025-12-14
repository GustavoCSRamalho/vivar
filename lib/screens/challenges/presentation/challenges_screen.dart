// // screens/challenges/challenges_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../packages/design_system_module/lib/src/constants/colors.dart';
// import '../../../../packages/design_system_module/lib/src/constants/text_styles.dart';
// import '../../../../packages/design_system_module/lib/src/constants/spacing.dart';
// import 'package:vivar/screens/challenges/presentation/widgets/challenge_card.dart';

// import '../../../../packages/authentication_module/lib/src/presentation/login/login_provider.dart';
// import 'providers/challenges_provider.dart';

// class ChallengesScreen extends StatefulWidget {
//   @override
//   _ChallengesScreenState createState() => _ChallengesScreenState();
// }

// class _ChallengesScreenState extends State<ChallengesScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadChallenges();
//     });
//   }

//   Future<void> _loadChallenges() async {
//     final user = context.read<LoginProvider>().currentUser;
//     if (user != null) {
//       await context.read<ChallengesProvider>().loadChallenges(user.id);
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundLight,
//       appBar: AppBar(
//         title: Text('Desafios'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.info_outline),
//             onPressed: _showInfoDialog,
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: AppColors.primary,
//           labelColor: AppColors.primary,
//           unselectedLabelColor: AppColors.textSecondary,
//           tabs: [
//             Tab(text: 'Ativos'),
//             Tab(text: 'Concluídos'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           _buildHeroSection(),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [_buildActiveChallenges(), _buildCompletedChallenges()],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeroSection() {
//     return Container(
//       height: 160,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('🏆', style: TextStyle(fontSize: 60)),
//             SizedBox(height: 12),
//             Text(
//               'Complete desafios',
//               style: AppTextStyles.h2.copyWith(color: Colors.white),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Ganhe badges e descontos exclusivos',
//               style: AppTextStyles.body.copyWith(
//                 color: Colors.white.withOpacity(0.9),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActiveChallenges() {
//     return Consumer<ChallengesProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading && provider.activeChallenges.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(color: AppColors.primary),
//           );
//         }

//         final challenges = provider.activeChallenges;

//         if (challenges.isEmpty) {
//           return _buildEmptyState(
//             'Nenhum desafio ativo',
//             'Novos desafios em breve!',
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: _loadChallenges,
//           child: ListView.builder(
//             padding: EdgeInsets.all(AppSpacing.horizontalPadding),
//             itemCount: challenges.length,
//             itemBuilder: (context, index) {
//               return ChallengeCard(
//                 challenge: challenges[index],
//                 isActive: true,
//                 onTap: () => _showChallengeDetails(challenges[index]),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCompletedChallenges() {
//     return Consumer<ChallengesProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading && provider.completedChallenges.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(color: AppColors.primary),
//           );
//         }

//         final challenges = provider.completedChallenges;

//         if (challenges.isEmpty) {
//           return _buildEmptyState(
//             'Nenhum desafio concluído',
//             'Complete desafios para desbloquear recompensas!',
//           );
//         }

//         return ListView.builder(
//           padding: EdgeInsets.all(AppSpacing.horizontalPadding),
//           itemCount: challenges.length,
//           itemBuilder: (context, index) {
//             return ChallengeCard(
//               challenge: challenges[index],
//               isActive: false,
//               onTap: () => _showChallengeDetails(challenges[index]),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildEmptyState(String title, String description) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('🎯', style: TextStyle(fontSize: 80)),
//             SizedBox(height: 16),
//             Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
//             SizedBox(height: 8),
//             Text(
//               description,
//               style: AppTextStyles.body.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showChallengeDetails(challenge) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 8),
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: AppColors.border,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: 24),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(challenge.title, style: AppTextStyles.h2),
//                   SizedBox(height: 8),
//                   Text(
//                     challenge.description,
//                     style: AppTextStyles.body.copyWith(
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   SizedBox(height: 24),
//                   if (challenge.isActive) ...[
//                     Text('Progresso', style: AppTextStyles.subtitle),
//                     SizedBox(height: 12),
//                     Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${challenge.currentCount}',
//                                 style: AppTextStyles.h1.copyWith(
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                               Text('Completado'),
//                             ],
//                           ),
//                           Text('de', style: AppTextStyles.body),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 '${challenge.targetCount}',
//                                 style: AppTextStyles.h1.copyWith(
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//                               Text('Meta'),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                   ],
//                   Text('Recompensas', style: AppTextStyles.subtitle),
//                   SizedBox(height: 12),
//                   if (challenge.rewardBadge != null)
//                     _buildDetailReward(
//                       Icons.emoji_events,
//                       'Badge Exclusivo',
//                       challenge.rewardBadge!,
//                     ),
//                   if (challenge.rewardPoints > 0)
//                     _buildDetailReward(
//                       Icons.star,
//                       'Pontos',
//                       '${challenge.rewardPoints} pontos',
//                     ),
//                   if (challenge.rewardDiscount != null)
//                     _buildDetailReward(
//                       Icons.local_offer,
//                       'Desconto',
//                       challenge.rewardDiscount!,
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailReward(IconData icon, String title, String value) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.inputBackground,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: AppColors.primary),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: AppTextStyles.bodySmall),
//                 SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: AppTextStyles.body.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showInfoDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Como funcionam os desafios?'),
//         content: Text(
//           'Complete desafios para ganhar badges exclusivos, pontos extras e descontos especiais. '
//           'Quanto mais você explora, mais recompensas você ganha!',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Entendi'),
//           ),
//         ],
//       ),
//     );
//   }
// }
