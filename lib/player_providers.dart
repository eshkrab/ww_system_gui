import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PlayerStateProvider with ChangeNotifier {
  // possible states can be 'playing', 'paused', 'stopped'
  String _playerState = 'stopped';

  String get playerState => _playerState;

  void setPlayerState(String state) {
    _playerState = state;
    notifyListeners();
  }
}

class PlayerModeProvider with ChangeNotifier {
  // possible modes can be 'repeat', 'repeat_one', 'halt'
  String _playerMode = 'halt';

  String get playerMode => _playerMode;

  void setPlayerMode(String mode) {
    _playerMode = mode;
    notifyListeners();
  }
}
