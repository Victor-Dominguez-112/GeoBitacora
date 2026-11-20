import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/evidence_provider.dart';
import 'screens/create_evidence_screen.dart';
import 'screens/evidence_detail_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GeoBitacoraApp());
}

class GeoBitacoraApp extends StatelessWidget {
  const GeoBitacoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EvidenceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoBitácora',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/nuevo': (context) => const CreateEvidenceScreen(),
          '/detalle': (context) => const EvidenceDetailScreen(),
        },
      ),
    );
  }
}