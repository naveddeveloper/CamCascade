import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSound(String fileName) async {
  await _player.play(AssetSource(fileName));
  await _player.setVolume(1.0);
  }

  static void dispose() {
    _player.dispose();
  }
}
