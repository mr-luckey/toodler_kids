import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/content_repository.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';

class StickerAlbumPage extends StatelessWidget {
  const StickerAlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticker Album 🌟'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<_StickerData>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: data.albums.map((album) {
              final filled = data.filledFor(album.id);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _albumTitle(album.nameKey),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: filled / album.slots,
                        color: const Color(0xFFFFB74D),
                      ),
                      const SizedBox(height: 4),
                      Text('$filled / ${album.slots} stickers'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: List.generate(album.slots.clamp(0, 20), (i) {
                          final unlocked = i < filled;
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: unlocked
                                  ? Colors.amber.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(unlocked ? '⭐' : '🔒'),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<_StickerData> _loadData() async {
    final content = getIt<ContentRepository>();
    final progress = getIt<ProgressRepository>();
    final albums = await content.getStickerAlbums();
    final allProgress = await progress.getAllLevelProgress();
    final completed = allProgress.values.where((p) => p.completed).length;
    return _StickerData(albums: albums, completedLevels: completed);
  }

  String _albumTitle(String key) {
    const map = {
      'album.animal_world': 'Animal World 🐾',
      'album.dinosaur_world': 'Dinosaur World 🦕',
      'album.space_explorers': 'Space Explorers 🚀',
      'album.number_wizards': 'Number Wizards 🔢',
      'album.letter_heroes': 'Letter Heroes 🔤',
      'album.color_masters': 'Color Masters 🌈',
      'album.world_travelers': 'World Travelers 🌍',
      'album.music_makers': 'Music Makers 🎵',
    };
    return map[key] ?? key;
  }
}

class _StickerData {
  _StickerData({required this.albums, required this.completedLevels});

  final List<StickerAlbumEntity> albums;
  final int completedLevels;

  int filledFor(String albumId) {
    switch (albumId) {
      case 'animal_world':
        return (completedLevels * 2).clamp(0, 50);
      case 'dinosaur_world':
        return completedLevels.clamp(0, 50);
      default:
        return (completedLevels ~/ 2).clamp(0, 50);
    }
  }
}
