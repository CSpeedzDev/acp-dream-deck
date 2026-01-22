import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../providers/category_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';
import 'dream_detail_screen.dart';
import 'action_feedback_screen.dart';

class NotTodayScreen extends StatelessWidget {
  const NotTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.nightlight_round, color: AppTheme.textPrimary),
            SizedBox(width: 8),
            Text(
              'Not Today',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DreamProvider>(
        builder: (context, dreamProvider, child) {
          final snoozedDreams = dreamProvider.snoozedDreams;

          if (snoozedDreams.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snoozedDreams.length,
            itemBuilder: (context, index) {
              final dream = snoozedDreams[index];
              return _buildSnoozedCard(context, dream);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.nightlight_round,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No snoozed ideas',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ideas you skip will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnoozedCard(BuildContext context, Dream dream) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        // Get category details
        final category = dream.categoryId != null
            ? categoryProvider.getCategoryById(dream.categoryId!)
            : null;

        final categoryColor = category?.color ?? dream.category.color;
        final categoryEmoji = category?.emoji ?? dream.category.emoji;
        final categoryName = category?.title ?? dream.category.displayName;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                categoryColor.withValues(alpha: 0.2),
                categoryColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DreamDetailScreen(dream: dream),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          categoryEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dream.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Snoozed until tomorrow',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary.withValues(alpha: 0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Restore button
                    IconButton(
                      onPressed: () {
                        dream.snoozedUntil = null;
                        Provider.of<DreamProvider>(context, listen: false)
                            .updateDream(dream);
                        
                        // Show animated feedback
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                ActionFeedbackScreen(actionType: ActionType.reactivated),
                            opaque: false,
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      color: categoryColor,
                      tooltip: 'Restore to shuffle',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
