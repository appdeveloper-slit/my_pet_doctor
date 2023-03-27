import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

class CallPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const CallPage(this.data, {Key? key}) : super(key: key);

  @override
  CallPageState createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  Map<String, dynamic> v = {};

  late RtcEngine rtcEngine;
  bool isMute = false;

  int? remoteID;

  @override
  void initState() {
    v = widget.data;
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    rtcEngine = await RtcEngine.create('e022219eb1d54317a609e0570d3680e5');
    await rtcEngine.enableVideo();
    await rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await rtcEngine.setClientRole(ClientRole.Broadcaster);
    eventHandler();
    //For Video Quality
    // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    // await rtcEngine.setVideoEncoderConfiguration(configuration);
    await rtcEngine.joinChannel(v['token'], v['channel'], null, 0);
  }

  void eventHandler() {
    rtcEngine.setEventHandler(
      RtcEngineEventHandler(
        userJoined: (uid, elapsed) {
          setState(() {
            remoteID = uid;
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            remoteID == null;
          });
          STM().back2Previous(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    closeConnection();
    super.dispose();
  }

  closeConnection() async {
    await rtcEngine.leaveChannel();
    await rtcEngine.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: remoteID != null ? withRemoteUser() : withoutRemoteUser(),
      ),
    );
  }

  Widget withoutRemoteUser() {
    return Stack(
      children: [
        const RtcLocalView.SurfaceView(),
        Center(
          child: Container(
            margin: EdgeInsets.only(
              top: Dim().d32,
            ),
            child: Column(
              children: [
                Container(
                  width: Dim().d100,
                  height: Dim().d100,
                  decoration: BoxDecoration(
                    color: const Color(0x801F98B3),
                    border: Border.all(
                      color: const Color(0xFF1F98B3),
                    ),
                    borderRadius: BorderRadius.circular(
                      Dim().d100,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      STM().nameShort('${v['name']}'),
                      style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Text(
                  '${v['name']}',
                  style: Sty().mediumText.copyWith(
                    color: Clr().white,
                  ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                Text(
                  'Calling...',
                  style: Sty().largeText.copyWith(
                    color: Clr().white,
                  ),
                ),
              ],
            ),
          ),
        ),
        controllerView(),
      ],
    );
  }

  Widget withRemoteUser() {
    return Stack(
      children: [
        Center(
          child: RtcRemoteView.SurfaceView(
            channelId: v['channel'],
            uid: remoteID ?? 0,
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            height: 150,
            child: Center(
              child: RtcLocalView.SurfaceView(),
            ),
          ),
        ),
        controllerView(),
      ],
    );
  }

  Widget controllerView() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              setState(() {
                isMute = !isMute;
              });
              rtcEngine.muteLocalAudioStream(isMute);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: isMute ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              isMute ? Icons.mic_off : Icons.mic,
              color: isMute ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              rtcEngine.switchCamera();
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }
}