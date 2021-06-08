/// Flutter doesn't have a nice way of formatting durations for some reason so I stole this code from StackOverflow
String printDuration(Duration? duration) {
  if (duration == null) {
    return "00:00";
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours >= 1) {
    String twoDigitHours = twoDigits(duration.inHours);
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  return "$twoDigitMinutes:$twoDigitSeconds";
}
