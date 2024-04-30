import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "186e397e5bb944fcb9b494b73f0fdf57";
const token =
    "007eJxTYPjxmb/5l+ixH+Gstd0rNne9vmLZuY9TPvuDwjZlxxWVon0KDIYWZqnGluappklJliYmaclJlkkmliZJ5sZpBmkpaabmB3bopzUEMjIkX3jIxMgAgSA+O0NuYkpyYk4OAwMAIoQiPw==";
const channel = "madcall";

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isCameraOn = true;
  bool _isCameraFront = true;
  bool _isMicrophoneOn = true;
  bool _isScreenShared = true;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
      _engine.enableLocalVideo(_isCameraOn);
    });
  }

  void _toggleCameraFront() {
    setState(() {
      _isCameraFront = !_isCameraFront;
    });
    _engine.switchCamera();
  }

  void _toggleScreenSharing() async {
    if (!_isScreenShared) {
      // Stop screen sharing
      await _engine.stopScreenCapture();
      setState(() {
        _isScreenShared = false;
      });
    } else {
      // Start screen sharing
      await _engine.startScreenCapture(ScreenCaptureParameters2());
      ChannelMediaOptions options = ChannelMediaOptions(
        publishCameraTrack: !_isScreenShared,
        publishMicrophoneTrack: !_isScreenShared,
        publishScreenTrack: _isScreenShared,
        publishScreenCaptureAudio: _isScreenShared,
        publishScreenCaptureVideo: _isScreenShared,
      );

      _engine.updateChannelMediaOptions(options);
    }
  }

  void _toggleMicrophone() {
    setState(() {
      _isMicrophoneOn = !_isMicrophoneOn;
      _engine.enableLocalAudio(_isMicrophoneOn);
    });
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _isCameraOn
                    ? _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : CircularProgressIndicator()
                    : Text("Video off"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(_isCameraOn ? Icons.videocam : Icons.videocam_off),
                  onPressed: _toggleCamera,
                ),
                IconButton(
                  icon: Icon(_isMicrophoneOn ? Icons.mic : Icons.mic_off),
                  onPressed: _toggleMicrophone,
                ),
                IconButton(
                  icon: Icon(_isCameraFront
                      ? Icons.camera_front_rounded
                      : Icons.camera_alt_outlined),
                  onPressed: _toggleCameraFront,
                ),
                IconButton(
                  icon: Icon(_isScreenShared
                      ? Icons.screen_share
                      : Icons.cancel_presentation),
                  onPressed: _toggleScreenSharing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return _isCameraOn
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: _remoteUid,sourceType: VideoSourceType.videoSourceScreen),
                connection: const RtcConnection(channelId: channel,),
              ),
            )
          : Text(
              'Video Off',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
