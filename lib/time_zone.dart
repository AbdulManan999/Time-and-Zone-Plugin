class TimeZone {
  TimeZone({
    bool? time,
    bool? zone,
  }) {
    _time = time;
    _zone = zone;
  }

  TimeZone.fromJson(dynamic json) {
    _time = json['time'];
    _zone = json['zone'];
  }
  bool? _time;
  bool? _zone;

  bool? get time => _time;
  bool? get zone => _zone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = _time;
    map['zone'] = _zone;
    return map;
  }
}
