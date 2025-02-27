// Information and Communication Technology

class Degree {
  final String name;
  final List<FocusArea> focusArea;

  Degree({required this.name, required this.focusArea});
}

class FocusArea {
  final String areaName;
  final String areaLetter;

  FocusArea({required this.areaName, required this.areaLetter});

  Map<String, dynamic> toJson() => {
        'areaName': areaName,
        'areaLetter': areaLetter,
      };

  factory FocusArea.fromJson(Map<String, dynamic> json) => FocusArea(
        areaName: json['areaName'],
        areaLetter: json['areaLetter'],
      );
  static final initFocusArea = FocusArea(areaLetter: "C", areaName: "Common");
}

final Degree ict = Degree(name: "ict", focusArea: [
  FocusArea(areaLetter: "C", areaName: "Common"),
  FocusArea(areaLetter: "S", areaName: "Software Technology"),
  FocusArea(areaLetter: "N", areaName: "Network Technology"),
  FocusArea(areaLetter: "M", areaName: "Multimedia Technology"),
]);
final Degree bst = Degree(name: "ict", focusArea: [
  FocusArea(areaLetter: "C", areaName: "Common"),
  FocusArea(
      areaLetter: "A", areaName: "Agriculture and Environmental Technology"),
  FocusArea(areaLetter: "F", areaName: "Food processing technology"),
  FocusArea(areaLetter: "I", areaName: "Industrial Biosystems technology"),
]);
final Degree egt = Degree(name: "ict", focusArea: [
  FocusArea(areaLetter: "C", areaName: "Common"),
  FocusArea(
      areaLetter: "B",
      areaName: "Construction and building services technology"),
  FocusArea(areaLetter: "E", areaName: "Energy and Environmental technology"),
  FocusArea(areaLetter: "G", areaName: "Geotechnology"),
  FocusArea(areaLetter: "T", areaName: "Automobile technology"),
  FocusArea(areaLetter: "M", areaName: "Mechatronics technology"),
  FocusArea(areaLetter: "P", areaName: "Polymer processing technology"),
]);
