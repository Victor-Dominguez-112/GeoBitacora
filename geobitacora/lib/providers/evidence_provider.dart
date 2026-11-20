import 'package:flutter/foundation.dart';
import '../models/field_evidence.dart';

class EvidenceProvider extends ChangeNotifier {
  final List<FieldEvidence> _evidences = [];

  List<FieldEvidence> get evidences => List.unmodifiable(_evidences);

  int get urgentCount => _evidences.where((e) => e.isUrgent).length;

  void addEvidence(FieldEvidence evidence) {
    _evidences.insert(0, evidence);
    notifyListeners();
  }
}