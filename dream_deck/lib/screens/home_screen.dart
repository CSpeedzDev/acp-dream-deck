import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'shuffle_screen.dart';
import 'memories_screen.dart';
import 'manifest_screen.dart';
import 'not_today_screen.dart';
import 'add_dream_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    ShuffleScreen(),
    ManifestScreen(),
    MemoriesScreen(),
  ];

  void _showAddDreamScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddDreamScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Row(
            key: ValueKey('fab-row-$_currentIndex'),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Moon button (Not Today) - Lower left - only on shuffle/memories
              if (_currentIndex != 1)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.indigo.shade900,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotTodayScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: const Icon(
                    Icons.nightlight_round,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Add button - Lower right
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryPurple, AppTheme.primaryPink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showAddDreamScreen,
                  borderRadius: BorderRadius.circular(32),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 72,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: _currentIndex == 0
                        ? Alignment.centerLeft
                        : _currentIndex == 1
                            ? Alignment.center
                            : Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: 1 / 3,
                      heightFactor: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryPurple, AppTheme.primaryPink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNavButton(
                          icon: Icons.shuffle,
                          label: 'Shuffle',
                          isActive: _currentIndex == 0,
                          onTap: () => setState(() => _currentIndex = 0),
                        ),
                      ),
                      Expanded(
                        child: _buildNavButton(
                          icon: Icons.playlist_add_check,
                          label: 'Manifest',
                          isActive: _currentIndex == 1,
                          onTap: () => setState(() => _currentIndex = 1),
                        ),
                      ),
                      Expanded(
                        child: _buildNavButton(
                          icon: Icons.favorite,
                          label: 'Memories',
                          isActive: _currentIndex == 2,
                          onTap: () => setState(() => _currentIndex = 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
