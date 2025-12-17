import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Sound Utility for UI Sound Effects
/// Handles button clicks, notifications, and other UI sounds
class Sounds {
  static final Sounds _instance = Sounds._internal();

  factory Sounds() => _instance;

  Sounds._internal();

  final Map<String, AudioPlayer> _sounds = {};
  final Map<String, Source> _sources = {};
  bool _enabled = true;
  double _volume = 0.5;

  /// Load a sound from an asset or URL
  ///
  /// [name] - Identifier for the sound
  /// [source] - Source of the audio (AssetSource, UrlSource, or DeviceFileSource)
  /// Returns true if loaded successfully
  Future<bool> load(String name, Source source) async {
    try {
      // Create a player for this sound
      final player = AudioPlayer();
      await player.setSource(source);
      await player.setVolume(_volume);

      _sounds[name] = player;
      _sources[name] = source;

      return true;
    } catch (error) {
      debugPrint('Failed to load sound "$name": $error');
      return false;
    }
  }

  /// Load a sound from assets
  ///
  /// [name] - Identifier for the sound
  /// [assetPath] - Path to the asset file (e.g., 'sounds/click.mp3')
  Future<bool> loadAsset(String name, String assetPath) async {
    return load(name, AssetSource(assetPath));
  }

  /// Load a sound from a URL
  ///
  /// [name] - Identifier for the sound
  /// [url] - URL of the audio file
  Future<bool> loadUrl(String name, String url) async {
    return load(name, UrlSource(url));
  }

  /// Load a sound from device file system
  ///
  /// [name] - Identifier for the sound
  /// [filePath] - Path to the file on device
  Future<bool> loadFile(String name, String filePath) async {
    return load(name, DeviceFileSource(filePath));
  }

  /// Load multiple sounds at once
  ///
  /// [sounds] - Map with name: source pairs
  /// Returns list of booleans indicating success for each sound
  Future<List<bool>> loadAll(Map<String, Source> sounds) async {
    final futures = sounds.entries.map((entry) => load(entry.key, entry.value));
    return Future.wait(futures);
  }

  /// Load multiple sounds from assets
  ///
  /// [sounds] - Map with name: assetPath pairs
  Future<List<bool>> loadAllAssets(Map<String, String> sounds) async {
    final futures = sounds.entries.map(
      (entry) => loadAsset(entry.key, entry.value),
    );
    return Future.wait(futures);
  }

  /// Play a loaded sound
  ///
  /// [name] - Name of the sound to play
  /// [volume] - Volume from 0.0 to 1.0 (optional, uses global volume if not specified)
  /// [rate] - Playback rate (1.0 is normal speed)
  /// [loop] - Whether to loop the sound
  Future<void> play(
    String name, {
    double? volume,
    double rate = 1.0,
    bool loop = false,
  }) async {
    if (!_enabled || !_sounds.containsKey(name)) {
      return;
    }

    try {
      final player = _sounds[name]!;
      final source = _sources[name]!;

      // Set playback parameters
      await player.setVolume(volume ?? _volume);
      await player.setPlaybackRate(rate);
      await player.setReleaseMode(
        loop ? ReleaseMode.loop : ReleaseMode.release,
      );

      // For overlapping sounds, create a new player instance
      if (player.state == PlayerState.playing) {
        final newPlayer = AudioPlayer();
        await newPlayer.setSource(source);
        await newPlayer.setVolume(volume ?? _volume);
        await newPlayer.setPlaybackRate(rate);
        await newPlayer.setReleaseMode(
          loop ? ReleaseMode.loop : ReleaseMode.release,
        );
        await newPlayer.resume();

        // Dispose after playing (if not looping)
        if (!loop) {
          newPlayer.onPlayerComplete.listen((_) {
            newPlayer.dispose();
          });
        }
      } else {
        await player.resume();
      }
    } catch (error) {
      debugPrint('Failed to play sound "$name": $error');
    }
  }

  /// Stop a sound
  ///
  /// [name] - Name of the sound to stop
  Future<void> stop(String name) async {
    if (_sounds.containsKey(name)) {
      try {
        await _sounds[name]!.stop();
      } catch (error) {
        debugPrint('Failed to stop sound "$name": $error');
      }
    }
  }

  /// Stop all sounds
  Future<void> stopAll() async {
    for (final player in _sounds.values) {
      try {
        await player.stop();
      } catch (error) {
        debugPrint('Failed to stop a sound: $error');
      }
    }
  }

  /// Pause a sound
  ///
  /// [name] - Name of the sound to pause
  Future<void> pause(String name) async {
    if (_sounds.containsKey(name)) {
      try {
        await _sounds[name]!.pause();
      } catch (error) {
        debugPrint('Failed to pause sound "$name": $error');
      }
    }
  }

  /// Resume a paused sound
  ///
  /// [name] - Name of the sound to resume
  Future<void> resume(String name) async {
    if (_enabled && _sounds.containsKey(name)) {
      try {
        await _sounds[name]!.resume();
      } catch (error) {
        debugPrint('Failed to resume sound "$name": $error');
      }
    }
  }

  /// Built-in click sound (requires 'click.mp3' to be loaded)
  /// For a programmatic click sound, use a short beep tone instead
  Future<void> click() async {
    if (_sounds.containsKey('click')) {
      await play('click');
    } else {
      // Fallback: play a short high-pitched tone if available
      debugPrint(
        'Click sound not loaded. Load a sound with name "click" first.',
      );
    }
  }

  /// Built-in success sound (requires 'success.mp3' to be loaded)
  Future<void> success() async {
    if (_sounds.containsKey('success')) {
      await play('success');
    } else {
      debugPrint(
        'Success sound not loaded. Load a sound with name "success" first.',
      );
    }
  }

  /// Built-in error sound (requires 'error.mp3' to be loaded)
  Future<void> error() async {
    if (_sounds.containsKey('error')) {
      await play('error');
    } else {
      debugPrint(
        'Error sound not loaded. Load a sound with name "error" first.',
      );
    }
  }

  /// Built-in notification sound (requires 'notification.mp3' to be loaded)
  Future<void> notification() async {
    if (_sounds.containsKey('notification')) {
      await play('notification');
    } else {
      debugPrint(
        'Notification sound not loaded. Load a sound with name "notification" first.',
      );
    }
  }

  /// Built-in pop sound (requires 'pop.mp3' to be loaded)
  /// For a programmatic click sound, use a short beep tone instead
  Future<void> pop() async {
    if (_sounds.containsKey('pop')) {
      await play('pop');
    } else {
      // Fallback: play a short high-pitched tone if available
      debugPrint('Click sound not loaded. Load a sound with name "pop" first.');
    }
  }

  /// Enable or disable all sounds
  ///
  /// [enabled] - Whether sounds should be enabled
  void setEnabled(bool enabled) {
    _enabled = enabled;
    if (!enabled) {
      stopAll();
    }
  }

  /// Set global volume
  ///
  /// [volume] - Volume from 0.0 to 1.0
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);

    // Update volume for all loaded sounds
    for (final player in _sounds.values) {
      try {
        await player.setVolume(_volume);
      } catch (error) {
        debugPrint('Failed to update volume: $error');
      }
    }
  }

  /// Get current global volume
  double getVolume() => _volume;

  /// Check if sounds are enabled
  bool isEnabled() => _enabled;

  /// Check if a sound is loaded
  bool isLoaded(String name) => _sounds.containsKey(name);

  /// Get the state of a sound
  PlayerState? getState(String name) {
    return _sounds[name]?.state;
  }

  /// Unload a sound and free memory
  ///
  /// [name] - Name of the sound to unload
  Future<void> unload(String name) async {
    if (_sounds.containsKey(name)) {
      try {
        await _sounds[name]!.stop();
        await _sounds[name]!.dispose();
        _sounds.remove(name);
        _sources.remove(name);
      } catch (error) {
        debugPrint('Failed to unload sound "$name": $error');
      }
    }
  }

  /// Unload all sounds
  Future<void> unloadAll() async {
    for (final name in _sounds.keys.toList()) {
      await unload(name);
    }
  }

  /// Dispose all resources (call when app is closing)
  Future<void> dispose() async {
    await unloadAll();
  }
}

// Global instance for easy access
final kSounds = Sounds();
