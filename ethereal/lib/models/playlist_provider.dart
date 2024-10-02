import 'package:audioplayers/audioplayers.dart';
import 'package:ethereal/models/song.dart';
import 'package:flutter/material.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Jo Tum Mere Ho",
      artistName: "Anuv Jain",
      albumArtImagePath: "assets/images/Jo Tum Mere Ho.jpg",
      audioPath:
          "https://raag.fm/files/mp3/128/Hindi-Singles/27381/Jo%20Tum%20Mere%20Ho%20-%20(Raag.Fm).mp3",
    ),
    Song(
      songName: "Jhoom",
      artistName: "Ali Zafar",
      albumArtImagePath: "assets/images/Jhoom.jpg",
      audioPath:
          "https://hindi3.djpunjab.app/load-hindi/q43fjdwmiq4W4Ox_Mk8kWg==/Jhoom%20(R%20%20B%20Mix).mp3",
    ),
    Song(
      songName: "Nadaaniyan",
      artistName: "Akshath",
      albumArtImagePath: "assets/images/Nadaaniyan.jpg",
      audioPath:
          "https://pagalall.com/wp-content/uploads/Nadaaniyan%20-%20Akshath%20(pagalall.com).mp3",
    ),
  ];

  int? _currentSongIndex = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlaylistProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async {
    try {
      if (_currentSongIndex == null) {
        print("Error: _currentSongIndex is null");
        return;
      }

      final String path = _playlist[_currentSongIndex!].audioPath;
      await _audioPlayer.stop();
      print("Playing audio from path: $path");
      await _audioPlayer.play(UrlSource(path));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
