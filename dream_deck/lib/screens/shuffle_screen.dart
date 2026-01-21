import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';
import '../widgets/dream_card.dart';

class ShuffleScreen extends StatefulWidget {
  const ShuffleScreen({super.key});

  @override
  State<ShuffleScreen> createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> {
  Dream? _currentDream;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRandomDream();
  }

  void _loadRandomDream() {
    final provider = Provider.of<DreamProvider>(context, listen: false);
    setState(() {
      _currentDream = provider.getRandomDream();
    });
  }

  void _shuffleDream() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _loadRandomDream();
      _isLoading = false;
    });
  }

  void _onSwipeLeft(Dream dream) {
    dream.snoozeFor24Hours();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('← Not now! See you in 24 hours'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _shuffleDream();
  }

  void _onSwipeRight(Dream dream) {
    dream.markAsCompleted();
    Provider.of<DreamProvider>(context, listen: false).updateDream(dream);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Let\'s do this! Added to Memories'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _shuffleDream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'DreamDeck',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            Text(
              'Shuffle your dreams ✨',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : _currentDream == null
                          ? _buildEmptyState()
                          : DreamCard(
                              dream: _currentDream!,
                              onSwipeLeft: _onSwipeLeft,
                              onSwipeRight: _onSwipeRight,
                            ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _shuffleDream,
                icon: const Icon(Icons.shuffle, size: 24),
                label: const Text(
                  'Shuffle!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  minimumSize: const Size(double.infinity, 60),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 60,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Tap shuffle to discover\nyour next adventure!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No dreams yet? Tap + to add one!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
