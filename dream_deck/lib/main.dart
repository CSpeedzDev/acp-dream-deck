import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/dream.dart';
import 'models/category.dart';
import 'models/manifest_item.dart';
import 'providers/dream_provider.dart';
import 'providers/category_provider.dart';
import 'providers/manifest_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(DreamAdapter());
  Hive.registerAdapter(DreamCategoryModelAdapter());
  Hive.registerAdapter(ManifestItemAdapter());
  Hive.registerAdapter(ChecklistItemAdapter());
  
  runApp(const DreamDeckApp());
}

class DreamDeckApp extends StatelessWidget {
  const DreamDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DreamProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => ManifestProvider()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'DreamDeck',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
