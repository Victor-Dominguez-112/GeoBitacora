import 'dart:typed_data';

class FieldEvidence {
  const FieldEvidence({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isUrgent,
    required this.latitude,
    required this.longitude,
    required this.capturedAt,
    required this.imageBytes,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final bool isUrgent;
  final double latitude;
  final double longitude;
  final DateTime capturedAt;
  final Uint8List imageBytes;
}