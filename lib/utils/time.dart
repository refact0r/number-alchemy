String msToString(int ms) {
  var duration = Duration(milliseconds: ms);
  var minutes = duration.inMinutes;
  var seconds = duration.inSeconds % 60;
  var milliseconds = (duration.inMilliseconds % 1000 / 10).round();
  return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
}
