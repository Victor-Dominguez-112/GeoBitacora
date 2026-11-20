import 'package:flutter/material.dart';
import '../models/field_evidence.dart';

class EvidenceDetailScreen extends StatelessWidget {
  const EvidenceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final evidence = ModalRoute.of(context)!.settings.arguments as FieldEvidence;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Evidencia'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: 'evidence_${evidence.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  evidence.imageBytes,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al Inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}