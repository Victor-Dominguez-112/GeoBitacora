import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/field_evidence.dart';
import '../providers/evidence_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _inspectorName = 'Cargando...';
  bool _onlyUrgent = false;

  final List<Map<String, Object>> _categories = const [
    {'name': 'Infraestructura', 'icon': Icons.construction, 'color': Colors.orange},
    {'name': 'Seguridad', 'icon': Icons.security, 'color': Colors.redAccent},
    {'name': 'Servicios', 'icon': Icons.electrical_services, 'color': Colors.blue},
    {'name': 'Otro', 'icon': Icons.assignment, 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    _loadInspectorName();
  }

  Future<void> _loadInspectorName() async {
    if (!mounted) return;
  }

  Future<void> _editInspectorDialog() async {
    final controller = TextEditingController(text: _inspectorName);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nombre del Inspector'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tu nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _loadInspectorName();
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvidenceProvider>();
    final List<FieldEvidence> displayedList = _onlyUrgent
        ? provider.evidences.where((e) => e.isUrgent).toList()
        : provider.evidences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoBitácora'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STACK: Encabezado superpuesto con persistencia en SharedPreferences
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.teal, Colors.tealAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenido,',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _inspectorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reportes totales: ${provider.evidences.length}  |  Urgentes: ${provider.urgentCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: _editInspectorDialog,
                    icon: const Icon(Icons.edit, color: Colors.white),
                    tooltip: 'Editar nombre guardado',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // GRIDVIEW: Categorías de reporte (2x2)
            const Text(
              'Categorías de Inspección',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: _categories.map((cat) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cat['color'] as Color),
                  ),
                  child: Row(
                    children: [
                      Icon(cat['icon'] as IconData, color: cat['color'] as Color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cat['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Control de filtro local con setState
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Evidencias Registradas',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text('Solo urgentes'),
                    Switch(
                      value: _onlyUrgent,
                      onChanged: (val) => setState(() => _onlyUrgent = val),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // LISTVIEW: Lista dinámica conectada a Provider
            if (displayedList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Aún no hay evidencias registradas.\nPresiona "Nuevo Reporte" para comenzar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedList.length,
                itemBuilder: (context, index) {
                  final item = displayedList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      // ANIMACIÓN HERO: Transición fluida de la imagen al detalle
                      leading: Hero(
                        tag: 'evidence_${item.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            item.imageBytes,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${item.category} • Lat: ${item.latitude.toStringAsFixed(3)}',
                      ),
                      trailing: item.isUrgent
                          ? const Icon(Icons.warning_amber_rounded, color: Colors.red)
                          : const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detalle',
                          arguments: item,
                        );
                      },
                    ),
                  );
                },
              ),
            const SizedBox(height: 70),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/nuevo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Nuevo Reporte'),
      ),
    );
  }
}