# 🌟 DreamDeck - Shuffle Your Dreams

A minimalist mobile app that stores personal aspirations (bucket list items) and brings them back to mind using a random algorithm ("shuffle"). Built with Flutter for an agile 40-hour project timebox.

![DreamDeck](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## 👥 Personas

**Lea (22, Chaotic Dreamer)** - Creative but chaotic, forgets ideas in everyday hustle. Needs inspiration, not another to-do list.

**Alex (23, Structured Implementer)** - Organized but lacking energy after work. Needs impulse and small achievable steps without pressure.

## ✨ Features Implemented

### 🎯 Core Features (All User Stories)

✅ **Quick Idea Capture (<5 seconds)**
- Floating + button on home screen
- Simple form with title (required), notes, and first step (optional)
- Category selection with 5 options
- Local storage with Hive

✅ **Shuffle Mechanism**
- Random dream display with beautiful gradient cards
- Prominent shuffle button
- Empty state guidance

✅ **Swipe Interactions**
- Swipe Left: Snooze for 24 hours ("Not now")
- Swipe Right/Tap: Mark as completed ("Let's do this!")
- Smooth animations with visual feedback
- 24-hour cooldown prevents pressure

✅ **Category System**
- 🌿 Outdoor
- 📚 Learning
- 🌸 Chill
- ⚡ Quick Win
- ✨ Big Dream

✅ **Mini-Steps for Big Ideas**
- Optional "First small step" field
- Prominently displayed on cards
- Lowers the barrier to starting

✅ **Memories Screen**
- Beautiful list of completed dreams
- Categorized with icons
- Option to reactivate dreams
- Empty state guidance

## 🎨 Design

- **Color Scheme**: Purple/Pink gradient (matches design reference)
- **UI/UX**: Minimalist, stress-free, no deadlines
- **Animations**: Smooth swipe gestures and transitions
- **Accessibility**: Clear visual hierarchy and feedback

## 🛠 Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Database**: Hive (Local NoSQL storage)
- **State Management**: Provider
- **Architecture**: Clean separation of concerns

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── dream.dart              # Dream model with Hive annotations
│   ├── dream.g.dart            # Generated Hive adapter
│   └── dream_category.dart     # Category enum with colors/emojis
├── providers/
│   └── dream_provider.dart     # State management for dreams
├── screens/
│   ├── home_screen.dart        # Main navigation
│   ├── shuffle_screen.dart     # Random dream display
│   ├── memories_screen.dart    # Completed dreams list
│   └── add_dream_screen.dart   # Capture new ideas
├── widgets/
│   └── dream_card.dart         # Swipeable dream card widget
└── theme/
    └── app_theme.dart          # App-wide theming
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or higher
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. Clone the repository
```bash
cd dream_deck
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate Hive adapters (if not already generated)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

## 📱 How to Use

1. **Add a Dream**: Tap the + button, enter your idea, optionally add a category and first step
2. **Shuffle**: Press the shuffle button to discover a random dream
3. **Interact**: 
   - Swipe left to snooze for 24 hours
   - Swipe right or tap to mark as completed
4. **View Memories**: Check the Memories tab to see completed dreams
5. **Reactivate**: Tap the replay icon to make a dream active again

## 🎯 User Stories Completed

| Story | Time | Status |
|-------|------|--------|
| Quick idea capture (<5s) | 4h | ✅ |
| See completed dreams (Memories) | 3h | ✅ |
| Swipe interactions with 24h cooldown | 9h | ✅ |
| Shuffle button with random selection | 6h | ✅ |
| Mini-step for big ideas | 2h | ✅ |
| Category assignment | 3h | ✅ |

**Total Implementation: ~27 hours** (within 40h timebox)

## 🔮 Future Enhancements (Out of Scope for MVP)

- Push notifications
- Cloud sync
- Social sharing
- Analytics/insights
- Search and filtering
- Image attachments
- Recurring dreams

## 📄 License

See LICENSE file for details.

## 👨‍💻 Development

This is an Agile Co-Creation project built in a 40-hour timebox, focusing on rapid prototyping and user-centered design.

**Methodology**: Agile with iterative development
**Focus**: Personas Lea & Alex - chaotic creativity meets structured implementation

---

Built with ❤️ using Flutter
