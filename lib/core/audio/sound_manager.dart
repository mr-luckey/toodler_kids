import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _voicePlayer = AudioPlayer();
  bool _enabled = true;

  bool get enabled => _enabled;

  void setEnabled(bool value) => _enabled = value;

  Future<void> playSfx(String soundKey) => _playAsset(_sfxPlayer, 'sfx', soundKey);

  Future<void> playVoice(String voiceKey) =>
      _playAsset(_voicePlayer, 'voice', voiceKey);

  Future<void> playPhonics(String letter) =>
      playVoice('letter_${letter.toLowerCase()}');

  Future<void> _playAsset(
    AudioPlayer player,
    String folder,
    String key,
  ) async {
    if (!_enabled) return;
    for (final ext in const ['ogg', 'mp3', 'wav']) {
      try {
        await player.play(AssetSource('audio/$folder/$key.$ext'));
        return;
      } catch (_) {
        // Try next extension
      }
    }
  }

  Future<void> dispose() async {
    await _sfxPlayer.dispose();
    await _voicePlayer.dispose();
  }
}
