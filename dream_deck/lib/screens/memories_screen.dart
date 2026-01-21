import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, color: AppTheme.primaryPink, size: 28),
                SizedBox(width: 8),
                Text(
                  'Memories',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPink,
                  ),
                ),
              ],
            ),
            Text(
              'Dreams you\'ve made real ✨',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
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
                color: AppTheme.primaryPink.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: AppTheme.primaryPink,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No memories yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start shuffling and mark dreams\nas done to see them here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, Dream dream, DreamProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              dream.category.color.withValues(alpha: 0.2),
              dream.category.color.withValues(alpha: 0.1),
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
                  color: dream.category.color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    dream.category.emoji,
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
                      dream.category.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        color: dream.category.color,
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dream is active again! 🎉'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
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
