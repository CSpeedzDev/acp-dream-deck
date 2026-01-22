import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:uuid/uuid.dart';
import '../providers/dream_provider.dart';
import '../providers/manifest_provider.dart';
import '../models/dream.dart';
import '../models/manifest_item.dart';
import '../theme/app_theme.dart';
import '../widgets/dream_card.dart';
import 'action_feedback_screen.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload the current dream to reflect any state changes
    if (_currentDream != null) {
      final provider = Provider.of<DreamProvider>(context, listen: false);
      final updatedDream = provider.allDreams.where((d) => d.id == _currentDream!.id).firstOrNull;
      if (updatedDream != null && (updatedDream.isCompleted || updatedDream.isSnoozed)) {
        // Current dream is no longer active, load a new one
        _loadRandomDream();
      }
    }
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

    final provider = Provider.of<DreamProvider>(context, listen: false);
    final activeDreams = provider.activeDreams;
    
    if (activeDreams.length < 2) return;

    setState(() {
      _isShuffling = true;
    });

    _spinController.forward(from: 0);

    // Cycle through cards during shuffle
    final cycleTimes = activeDreams.length.clamp(2, 5); // Show 2-5 cards max
    for (int i = 0; i < cycleTimes; i++) {
      await Future.delayed(Duration(milliseconds: 150 + (i * 50))); // Increasing delay
      if (mounted) {
        setState(() {
          _currentDream = activeDreams[i % activeDreams.length];
        });
      }
    }

    // Final delay before showing the selected card
    await Future.delayed(const Duration(milliseconds: 200));

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
    Provider.of<DreamProvider>(context, listen: false).updateDream(dream);
    
    // Show animated feedback
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ActionFeedbackScreen(actionType: ActionType.snoozed),
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    
    _shuffleDream();
  }

  void _onSwipeRight(Dream dream) {
    // Check if manifest already exists
    final manifestProvider = Provider.of<ManifestProvider>(context, listen: false);
    final existingManifest = manifestProvider.getManifestByDreamId(dream.id);
    
    if (existingManifest != null) {
      // Already has a manifest, just show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This dream is already being tracked!'),
          duration: Duration(seconds: 2),
        ),
      );
      _shuffleDream();
      return;
    }
    
    // Create a manifest without goals - goals will be added via "Start Tracking"
    final manifest = ManifestItem(
      id: const Uuid().v4(),
      dreamId: dream.id,
      title: dream.title,
      checklist: [],
      goalValues: {},
      startedAt: DateTime.now(),
    );
    
    manifestProvider.addManifest(manifest);
    
    // Show animated feedback
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ActionFeedbackScreen(actionType: ActionType.manifested),
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
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
        
        // Check if current dream is still active, if not reload
        if (_currentDream != null) {
          final isStillActive = provider.activeDreams.any((d) => d.id == _currentDream!.id);
          if (!isStillActive && hasAnyDreams) {
            // Current dream is no longer active, schedule reload
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _loadRandomDream();
              }
            });
          } else if (!hasAnyDreams) {
            // No more active dreams
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentDream = null;
                });
              }
            });
          }
        } else if (hasAnyDreams) {
          // We had no dream but now there are dreams, load one
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _loadRandomDream();
            }
          });
        }

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
                              key: ValueKey(_currentDream!.id),
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
            color: AppTheme.textSecondary.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
