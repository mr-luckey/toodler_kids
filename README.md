# KidsLearnPlay

Complete educational app for toddlers 3-5 — Flutter + BLoC + Clean Architecture.

## What's Included

| Feature | Count |
|---------|-------|
| Complete Picture levels | **500** |
| Animal World + Names | 180 |
| Numbers + Counting | 200 |
| Letters + Phonics | 200 |
| Dinosaur + Space | 200 |
| Shadow Game | 100 |
| Which Tool Works | 100 |
| True/False (3 categories) | 260 |
| What Am I riddles | 80 |
| Build a Scene | 18 |
| Sports, Seasons, Household | 280 |
| Colors + Opposites | 200 |
| Drawing templates | **50** |
| Sticker albums | 8 |
| Fun facts | 100 |
| Wonder Island zones | **14** |

**Total: ~3,500+ playable JSON levels**

## Run

```bash
flutter pub get
dart run tool/generate_content.dart
flutter run
```

## Architecture

- **Universal GamePlayPage** — one screen for all 11 game mechanics
- **JSON-driven** — zero hardcoded game content
- **Drawing Den** — smooth bezier draw + tap-to-fill (24 colors)
- **Lumi mascot** — 8 emotions, scaffold hints
- **Parent dashboard** — learning map + PDF export
- **Adaptive engine** — spaced repetition
- **Offline-first** — Hive local storage

## Game Mechanics

Tap Match · Select Piece · Drag & Drop · True/False · Riddle · Sandbox · Sequence · Simon · Color Fill · Trace · Tap Reveal

## Android

- Package: `com.kidslearnplay.toddler.games`
- Min SDK: 24
- Play Families compliant
