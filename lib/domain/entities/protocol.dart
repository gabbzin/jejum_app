class Protocol {
  final String id;
  final String name;
  final int fastingHours;
  final int eatingHours;
  final bool isCustom;

  const Protocol({
    required this.id,
    required this.name,
    required this.fastingHours,
    required this.eatingHours,
    this.isCustom = false,
  });

  static const predefined = [
    Protocol(
      id: '12:12',
      name: '12:12',
      fastingHours: 12,
      eatingHours: 12,
      isCustom: false,
    ),
    Protocol(
      id: '16:8',
      name: '16:8',
      fastingHours: 16,
      eatingHours: 8,
      isCustom: false,
    ),
    Protocol(
      id: '18:6',
      name: '18:6',
      fastingHours: 18,
      eatingHours: 6,
      isCustom: false,
    ),
  ];
}
