String msToString(int ms) {
  var duration = Duration(milliseconds: ms);
  var minutes = duration.inMinutes;
  var seconds = duration.inSeconds % 60;
  var milliseconds = duration.inMilliseconds % 1000;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0')}';
}
