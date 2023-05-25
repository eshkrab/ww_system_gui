import 'package:flutter/material.dart';

const String appTitle = 'Player App';

final List<BottomNavigationBarItem> bottomNavItems = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.control_camera),
    label: 'Control',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.playlist_play),
    label: 'Playlist',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: 'Settings',
  ),
];

const int frameRate = 30;
const defaultIp = '192.168.86.144';
const defaultPort = 8000;
const darkModeDefaultValue = true;

const appPrimaryColor = Colors.teal;
const appAccentColor = Colors.tealAccent;

const brightnessOptions = ['Auto', 'Light', 'Dark'];

const playlistOptions = ['REPEAT', 'REPEAT_ONE', 'REPEAT_NONE'];
const String playerModeRepeat = 'repeat';
const String playerModeRepeatOne = 'repeat_one';
const String playerModeStop = 'stop';

const defaultplayerMode = 'REPEAT';

const dialogDeleteVideoTitle = 'Delete Video';
const dialogDeleteVideoContent = 'Are you sure you want to delete this video?';

const buttonSave = 'Save';
const buttonEdit = 'Edit';
const buttonCancel = 'Cancel';
const buttonUpload = 'Upload';
const buttonAddVideo = 'Add Video';
const buttonDelete = 'Delete';

const labelServerIP = 'Server IP Address';
const labelServerPort = 'Server Port';
const labelAppDarkMode = 'App Dark Mode';

const String websocketURL = 'ws://192.168.86.22:5000/websocket';

const String playerStatePlaying = 'playing';
const String playerStatePaused = 'paused';
const String playerStateStopped = 'stopped';

const String failedToSendRequest = 'Failed to send request';
const String failedToSetBrightness = 'Failed to Set brightness';
const String failedToGetBrightness = 'Failed to get brightness';

const String failedToSetState = 'Failed to Set State';
const String failedToGetState = 'Failed to get State';
const String failedToSetMode = 'Failed to Set Mode';
const String failedToGetMode = 'Failed to get Mode';
