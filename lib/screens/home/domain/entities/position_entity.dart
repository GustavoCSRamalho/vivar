/// Modelo simples para posição
class Position {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  Position({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });
}
