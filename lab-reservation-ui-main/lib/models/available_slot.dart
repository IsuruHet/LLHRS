class AvailableSlot {
  final String id;
  final String hlName;

  AvailableSlot({
    required this.id,
    required this.hlName,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      id: json['_id'],
      hlName: json['hl_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'hl_name': hlName,
    };
  }
}
