extension DurationFormatter on Duration {
  /// Returns the minutes:seconds representation from a duration
  String simpleFormat() {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final twoDigitMinutes = twoDigits(inMinutes.remainder(60) as int);
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60) as int);
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
