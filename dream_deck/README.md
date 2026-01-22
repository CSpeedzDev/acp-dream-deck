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
- Floating + button with gradient styling
- Simple form with title (required), notes, and first step (optional)
- Category selection with 5 options
- Button disabled until title is entered
- Local storage with Hive

✅ **Shuffle Mechanism**
- Random dream display with beautiful gradient cards
- Animated spinning shuffle button
- "Shuffling..." text during animation
- Empty state guidance

✅ **Dream Detail View**
- Tap any card to see full details
- Displays category, title, first step, and notes
- "Mark as Done" button with hover effect
- "Back to Shuffle" button with hover effect
- Clean, organized layout

✅ **Swipe Interactions**
- Swipe Left: Snooze for 24 hours ("Not now")
- Swipe Right: Mark as completed ("Let's do this!")
- Smooth animations with visual feedback
- 24-hour cooldown prevents pressure

✅ **iOS-Style Navigation**
- Sliding toggle animation between views
- Gradient background follows active tab
- Smooth 300ms transitions

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

### 🌟 Nice-to-Have Features (Beyond Core Stories)

✅ **Manifest System - Progress Tracking**
- Transform dreams into actionable manifests
- Two tracking modes:
  - **Checklist Mode**: Track progress with subtasks
  - **Numeric Mode**: Track measurable goals with current/target values
- Create manifests directly from dream detail view
- Edit tracking goals after creation
- View detailed progress with visual indicators
- Delete manifests to move dreams back to shuffle pool
- Beautiful progress cards with completion percentages

✅ **Advanced Dream Management**
- Delete dreams permanently from detail view
- Contextual action feedback screens for all major actions
- Animated feedback for: completing, snoozing, reactivating, manifesting, and deleting
- Conditional UI elements (e.g., snooze button only appears when snoozed dreams exist)

✅ **Enhanced UX & Polish**
- Consistent empty state styling across all screens
- Standardized fonts, sizes, and text alignment
- Properly positioned floating action buttons
- Overflow protection for long content
- Smooth animations and transitions throughout

✅ **Snoozed Dreams Management**
- Dedicated "Not Today" screen for snoozed dreams
- 24-hour cooldown system
- Visual countdown until dreams become available again
- Quick reactivation from snoozed view

✅ **Custom Category System**
- Create custom categories beyond the 5 defaults
- Assign custom emoji and color to each category
- Manage categories through dedicated settings
- Persist custom categories across sessions

✅ **Database Integration**
- Full CRUD operations with Hive database
- Persistent storage for dreams, manifests, and categories
- Automatic data synchronization across screens
- State management with Provider pattern

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
│   ├── dream_category.dart     # Category enum with colors/emojis
│   ├── manifest_item.dart      # Manifest model for progress tracking
│   └── manifest_item.g.dart    # Generated Hive adapter
├── providers/
│   ├── dream_provider.dart     # State management for dreams
│   ├── manifest_provider.dart  # State management for manifests
│   └── category_provider.dart  # State management for categories
├── screens/
│   ├── home_screen.dart        # Main navigation with 3 tabs
│   ├── shuffle_screen.dart     # Random dream display
│   ├── memories_screen.dart    # Completed dreams list
│   ├── manifest_screen.dart    # Progress tracking for dreams
│   ├── not_today_screen.dart   # Snoozed dreams management
│   ├── add_dream_screen.dart   # Capture new ideas
│   ├── dream_detail_screen.dart # Dream details with actions
│   └── action_feedback_screen.dart # Animated action confirmations
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
3. **View Details**: Tap on a dream card to see full details
4. **Interact**: 
   - Swipe left to snooze for 24 hours
   - Swipe right to mark as completed
   - Or use the detail view buttons
5. **Track Progress**: Create a manifest to track your dream with checklists or numeric goals
6. **View Memories**: Check the Memories tab to see completed dreams
7. **Manage Snoozed**: View and reactivate snoozed dreams in the moon menu
8. **Reactivate**: Tap the replay icon to make a dream active again
9. **Delete**: Remove dreams permanently or delete manifests to return dreams to shuffle

### 💾 Data Persistence

**Mobile/Desktop**: Data is permanently stored locally using Hive database.

**Web**: Data is stored in browser IndexedDB. Note that:
- Data persists across page refreshes in the same browser
- Clearing browser data will reset the app
- Different browsers/private modes have separate storage
- This is expected behavior for web apps using local storage

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

- Push notifications for snoozed dreams
- Cloud sync across devices
- Social sharing of achievements
- Analytics/insights dashboard
- Advanced search and filtering
- Image attachments for dreams
- Recurring dreams/habits
- Export/import functionality
- Collaboration features

## 📊 Implementation Notes

**Core User Stories**: ~27 hours (within initial scope)
**Nice-to-Have Features**: Additional development time invested in:
- Manifest tracking system (checklist + numeric modes)
- Enhanced dream management (delete, edit goals)
- Snoozed dreams screen
- Custom category management
- Action feedback animations
- Comprehensive UX polish and consistency

All features are production-ready with proper error handling, state management, and database persistence.

## 📄 License

See LICENSE file for details.

## 👨‍💻 Development

This is an Agile Co-Creation project built in a 40-hour timebox, focusing on rapid prototyping and user-centered design.

**Methodology**: Agile with iterative development
**Focus**: Personas Lea & Alex - chaotic creativity meets structured implementation

---

Built with ❤️ using Flutter
