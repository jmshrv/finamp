/// Flutter doesn't have a nice way of formatting durations for some reason so I stole this code from StackOverflow
String printDuration(
  Duration? duration, {
  bool isRemaining = false,
  bool leadingZeroes = true,
}) {
  if (duration == null) {
    return "00:00";
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final minutes = duration.inMinutes.remainder(60);
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  String durationString;
  if (duration.inHours >= 1) {
    String paddedHours = leadingZeroes ? twoDigits(duration.inHours) : duration.inHours.toString();
    durationString = "$paddedHours:${twoDigits(minutes)}:$twoDigitSeconds";
  } else {
    String paddedMinutes = leadingZeroes ? twoDigits(minutes) : minutes.toString();
    durationString = "$paddedMinutes:$twoDigitSeconds";
  }

  if (isRemaining) {
    durationString = "-$durationString";
  }

  return durationString;
}
