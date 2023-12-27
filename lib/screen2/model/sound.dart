import 'package:audioplayers/audioplayers.dart';

Future<void> playSoundChat() async {
  print(DateTime.now());
  const alarmAudioPath = "chat.mp3";
  var p = AudioPlayer();
  p.setReleaseMode(ReleaseMode.stop);
  await p.play(AssetSource(alarmAudioPath), mode: PlayerMode.lowLatency);
  //await player.stop();
  //player.dispose();
  print(DateTime.now());
}