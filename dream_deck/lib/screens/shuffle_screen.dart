import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/dream_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';
import '../widgets/dream_card.dart';

class ShuffleScreen extends StatefulWidget {
  const ShuffleScreen({super.key});

  @override
  State<ShuffleScreen> createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> with SingleTickerProviderStateMixin {
  Dream? _currentDream;
  bool _isShuffling = false;
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _spinAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );
    _loadRandomDream();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _loadRandomDream() {
    final provider = Provider.of<DreamProvider>(context, listen: false);
    setState(() {
      _currentDream = provider.getRandomDream();
    });
  }

  void _shuffleDream() async {
    if (_isShuffling) return;

    setState(() {
      _isShuffling = true;
    });

    _spinController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _loadRandomDream();
    });

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      _isShuffling = false;
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
    return Consumer<DreamProvider>(
      builder: (context, provider, child) {
        final activeDreamsCount = provider.activeDreams.length;
        final canShuffle = activeDreamsCount >= 2;
        final hasAnyDreams = activeDreamsCount > 0;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppTheme.primaryPurple,
                      AppTheme.primaryPink,
                      Colors.orange.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'DreamDeck',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text(
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
                      child: _currentDream == null
                          ? _buildEmptyState(hasAnyDreams)
                          : DreamCard(
                              dream: _currentDream!,
                              onSwipeLeft: _onSwipeLeft,
                              onSwipeRight: _onSwipeRight,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (hasAnyDreams && canShuffle)
                    AnimatedBuilder(
                      animation: _spinAnimation,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryPurple, AppTheme.primaryPink],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isShuffling ? null : _shuffleDream,
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: _spinAnimation.value,
                                      child: const Icon(
                                        Icons.shuffle,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _isShuffling ? 'Shuffling...' : 'Shuffle!',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (hasAnyDreams && canShuffle) const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool hasAnyDreams) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: hasAnyDreams 
                ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 60,
            color: hasAnyDreams 
                ? AppTheme.primaryPurple 
                : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          hasAnyDreams 
              ? 'Tap shuffle to discover\nyour next adventure!'
              : 'No ideas yet!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          hasAnyDreams
              ? 'Add more dreams to shuffle!'
              : 'Add some dreams to get started.',
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
