enum Shift {
  morning("Morning", 6),
  day("Noon", 12),
  night("Night", 18),
  any("Anytime", 0);

  final String label;
  final int startHour;

  const Shift(this.label, this.startHour);

  bool get isMorning => this == morning;

  bool get isDay => this == day;

  bool get isNight => this == night;

  bool get isAny => this == any;

  String get source => name;

  bool isRunning(Shift type) => this == type;

  bool isRunningAt(int index) => values[index] == this;

  bool isPast(int hour) => hour > startHour;

  bool isFuture(int hour) => hour < startHour;

  factory Shift.parse(Object? source) {
    final x = values.where((e) {
      if (e == source) return true;
      if (e.toString().toLowerCase() == source.toString().toLowerCase()) {
        return true;
      }
      if (e.name.toLowerCase() == source.toString().toLowerCase()) {
        return true;
      }
      if (e.index == source) return true;
      return false;
    }).firstOrNull;
    return x ?? Shift.any;
  }

  factory Shift.detect([int? hour]) {
    final time = hour ?? DateTime.now().hour;
    if (time >= morning.startHour && time < day.startHour) return Shift.morning;
    if (time >= day.startHour && time <= night.startHour) return Shift.day;
    if (time < morning.startHour || time > night.startHour) return Shift.night;
    return Shift.any;
  }
}
