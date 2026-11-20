import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/field_evidence.dart';
import '../providers/evidence_provider.dart';

class CreateEvidenceScreen extends StatefulWidget {
  const CreateEvidenceScreen({super.key});

  @override
  State<CreateEvidenceScreen> createState() => _CreateEvidenceScreenState();
}

class _CreateEvidenceScreenState extends State<CreateEvidenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();


  final List<String> _categories = ['Infraestructura', 'Seguridad', 'Servicios', 'Otro'];
  String _selectedCategory = 'Infraestructura';
  bool _isUrgent = false;

  Uint8List? _imageBytes;
  double? _latitude;
  double? _longitude;
  DateTime? _capturedAt;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveReport() {
    if (!_formKey.currentState!.validate()) return;

    if (_imageBytes == null || _latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero captura la ubicación GPS y la fotografía.'),
        ),
      );
      return;
    }

    final newEvidence = FieldEvidence(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory,
      isUrgent: _isUrgent,
      latitude: _latitude!,
      longitude: _longitude!,
      capturedAt: _capturedAt ?? DateTime.now(),
      imageBytes: _imageBytes!,
    );

    context.read<EvidenceProvider>().addEvidence(newEvidence);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Evidencia'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título del reporte',
                  hintText: 'Ej. Luminaria dañada en pasillo B',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción / Observaciones',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Agrega una breve descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ANIMATEDCONTAINER: Selección animada de categoría
              const Text(
                'Categoría:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Marcar como reporte urgente'),
                value: _isUrgent,
                onChanged: (val) => setState(() => _isUrgent = val),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 16),

              if (_imageBytes != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coordenadas capturadas: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _saveReport,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar en Bitácora'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}