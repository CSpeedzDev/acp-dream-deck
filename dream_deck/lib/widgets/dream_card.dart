import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../screens/dream_detail_screen.dart';

class DreamCard extends StatefulWidget {
  final Dream dream;
  final Function(Dream)? onSwipeLeft;
  final Function(Dream)? onSwipeRight;

  const DreamCard({
    super.key,
    required this.dream,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  State<DreamCard> createState() => _DreamCardState();
}

class _DreamCardState extends State<DreamCard>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0;
  bool _isDragging = false;
  late AnimationController _hueController;
  late Animation<double> _hueAnimation;

  @override
  void initState() {
    super.initState();
    _hueController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _hueAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _hueController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final swipeProgress = (_dragOffset.abs() / 100).clamp(0.0, 1.0);
    final isSwipingLeft = _dragOffset < 0;

    return GestureDetector(
      onTap: () {
        // Open detail screen when tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DreamDetailScreen(dream: widget.dream),
          ),
        );
      },
      onHorizontalDragStart: (_) {
        setState(() {
          _isDragging = true;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset.abs() > 100) {
          if (_dragOffset < 0) {
            widget.onSwipeLeft?.call(widget.dream);
          } else {
            widget.onSwipeRight?.call(widget.dream);
          }
        }
        setState(() {
          _dragOffset = 0;
          _isDragging = false;
        });
      },
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Transform.rotate(
          angle: _dragOffset * 0.001,
          child: Stack(
            children: [
              _buildCard(),
              if (_isDragging && swipeProgress > 0.3)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSwipingLeft
                          ? Colors.red.withValues(alpha: 0.2 * swipeProgress)
                          : Colors.green.withValues(alpha: 0.2 * swipeProgress),
                    ),
                    child: Center(
                      child: Icon(
                        isSwipingLeft ? Icons.close : Icons.check,
                        size: 80,
                        color: isSwipingLeft
                            ? Colors.red.withValues(alpha: swipeProgress)
                            : Colors.green.withValues(alpha: swipeProgress),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: _hueAnimation,
      builder: (context, child) {
        final baseColor = widget.dream.category.color;
        final hslColor = HSLColor.fromColor(baseColor);
        final animatedColor = hslColor
            .withHue((hslColor.hue + _hueAnimation.value * 20) % 360)
            .toColor();

        return Card(
          elevation: 8,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  animatedColor.withValues(alpha: 0.9),
                  baseColor.withValues(alpha: 0.95),
                  baseColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: animatedColor.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.dream.category.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.dream.category.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Dream title
                Text(
                  widget.dream.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                // First step section
                if (widget.dream.firstStep != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'START WITH:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.dream.firstStep!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                // Swipe hints
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSwipeHint('← Not now', Colors.white.withValues(alpha: 0.7)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Tap to see details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildSwipeHint('Let\'s do this! →', Colors.white.withValues(alpha: 0.7)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeHint(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
