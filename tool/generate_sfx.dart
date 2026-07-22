// Generates kid-friendly WAV sound effects.
// Run: dart run tool/generate_sfx.dart

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final dir = Directory('assets/audio/sfx');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  _save('wow.wav', _wow());
  _save('chime.wav', _chime());
  _save('soft_boop.wav', _softBoop());
  _save('color_fill.wav', _chime(volume: 0.45, duration: 0.12));
  _save('celebration.wav', _wow()); // legacy key alias

  const padNotes = [261.63, 329.63, 392.0, 523.25]; // C4 E4 G4 C5
  for (var i = 0; i < padNotes.length; i++) {
    _save('pad_$i.wav', _note(padNotes[i], duration: 0.28, volume: 0.55));
  }

  stdout.writeln('✅ Generated ${dir.listSync().length} sfx files in assets/audio/sfx/');
}

void _save(String name, Float64List samples) {
  File('assets/audio/sfx/$name').writeAsBytesSync(_encodeWav(samples));
  stdout.writeln('  ✓ $name');
}

/// Cheerful "wow!" — quick rising arpeggio.
Float64List _wow() {
  const sr = 22050;
  const duration = 0.65;
  final n = (sr * duration).round();
  final out = Float64List(n);
  final notes = [
    (freq: 523.25, start: 0.0, len: 0.12),
    (freq: 659.25, start: 0.08, len: 0.12),
    (freq: 783.99, start: 0.16, len: 0.14),
    (freq: 1046.5, start: 0.24, len: 0.35),
  ];
  for (var i = 0; i < n; i++) {
    final t = i / sr;
    var v = 0.0;
    for (final note in notes) {
      if (t < note.start || t > note.start + note.len) continue;
      final local = (t - note.start) / note.len;
      final env = sin(pi * local).clamp(0.0, 1.0);
      v += sin(2 * pi * note.freq * t) * env;
    }
    out[i] = (v * 0.35).clamp(-1.0, 1.0);
  }
  return out;
}

Float64List _chime({double volume = 0.4, double duration = 0.18}) {
  const sr = 22050;
  final n = (sr * duration).round();
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sr;
    final env = exp(-t * 14);
    final v = (sin(2 * pi * 880 * t) + 0.35 * sin(2 * pi * 1320 * t)) * env;
    out[i] = (v * volume).clamp(-1.0, 1.0);
  }
  return out;
}

Float64List _softBoop({double duration = 0.22}) {
  const sr = 22050;
  final n = (sr * duration).round();
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sr;
    final env = exp(-t * 8);
    final freq = 220 + 80 * (1 - t / duration);
    out[i] = (sin(2 * pi * freq * t) * env * 0.35).clamp(-1.0, 1.0);
  }
  return out;
}

Float64List _note(double freq, {required double duration, required double volume}) {
  const sr = 22050;
  final n = (sr * duration).round();
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sr;
    final env = sin(pi * t / duration).clamp(0.0, 1.0) * exp(-t * 3.5);
    final v = sin(2 * pi * freq * t) + 0.25 * sin(2 * pi * freq * 2 * t);
    out[i] = (v * env * volume).clamp(-1.0, 1.0);
  }
  return out;
}

Uint8List _encodeWav(Float64List samples, {int sampleRate = 22050}) {
  final byteRate = sampleRate * 2;
  final dataSize = samples.length * 2;
  final buffer = ByteData(44 + dataSize);

  void str(int offset, String s) {
    for (var i = 0; i < s.length; i++) {
      buffer.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  buffer.setUint32(4, 36 + dataSize, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  buffer.setUint32(16, 16, Endian.little);
  buffer.setUint16(20, 1, Endian.little);
  buffer.setUint16(22, 1, Endian.little);
  buffer.setUint32(24, sampleRate, Endian.little);
  buffer.setUint32(28, byteRate, Endian.little);
  buffer.setUint16(32, 2, Endian.little);
  buffer.setUint16(34, 16, Endian.little);
  str(36, 'data');
  buffer.setUint32(40, dataSize, Endian.little);

  var offset = 44;
  for (final s in samples) {
    final clamped = (s * 32767).round().clamp(-32768, 32767);
    buffer.setInt16(offset, clamped, Endian.little);
    offset += 2;
  }
  return buffer.buffer.asUint8List();
}
