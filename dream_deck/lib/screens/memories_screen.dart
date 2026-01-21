import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../providers/category_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';
import 'action_feedback_screen.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<DreamProvider>(
          builder: (context, provider, child) {
            final hasMemories = provider.completedDreams.isNotEmpty;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasMemories ? Icons.favorite : Icons.favorite_border,
                      color: AppTheme.primaryPink,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Memories',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Dreams you\'ve made real ✨',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Consumer<DreamProvider>(
        builder: (context, provider, child) {
          final completedDreams = provider.completedDreams;

          if (completedDreams.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedDreams.length,
            itemBuilder: (context, index) {
              final dream = completedDreams[index];
              return _buildMemoryCard(context, dream, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
                Icons.favorite_border,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No memories yet',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start shuffling and mark dreams\nas done to see them here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, Dream dream, DreamProvider provider) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categoryColor = dream.categoryId != null
            ? (categoryProvider.getCategoryById(dream.categoryId!)?.color ??
                dream.category.color)
            : dream.category.color;
        
        final categoryEmoji = dream.categoryId != null
            ? (categoryProvider.getCategoryById(dream.categoryId!)?.emoji ??
                dream.category.emoji)
            : dream.category.emoji;
        
        final categoryName = dream.categoryId != null
            ? (categoryProvider.getCategoryById(dream.categoryId!)?.title ??
                dream.category.displayName)
            : dream.category.displayName;
        
        return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withValues(alpha: 0.2),
              categoryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
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
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Reactivate button
              IconButton(
                icon: const Icon(Icons.replay, color: AppTheme.textSecondary),
                tooltip: 'Do it again',
                onPressed: () {
                  _showReactivateDialog(context, dream, provider);
                },
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  void _showReactivateDialog(BuildContext context, Dream dream, DreamProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make it active again?'),
        content: Text(
          'Do you want to experience "${dream.title}" again?\nIt will be added back to your shuffle deck.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              dream.markAsActive();
              provider.updateDream(dream);
              Navigator.pop(context);
              
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
            child: const Text('Yes, activate!'),
          ),
        ],
      ),
    );
  }
}
