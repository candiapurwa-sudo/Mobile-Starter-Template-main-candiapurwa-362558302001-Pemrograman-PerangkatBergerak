import 'package:flutter/material.dart';
import '../../../modul_06/services/auth_api.dart';
import '../../../modul_06/services/sesi_memori.dart';
import 'controllers/sesi_controller.dart';
import 'repositories/aman_sesi_repository.dart';
import 'repositories/memori_sesi_repository.dart';
import 'repositories/prefs_sesi_repository.dart';
import 'repositories/sesi_repository.dart';
import 'screens/beranda_pengayaan_screen.dart';
import 'screens/login_pengayaan_screen.dart';
import 'storage/penyimpanan_aman_platform.dart';
import 'widgets/gerbang_sesi.dart';

class Modul06PengayaanApp extends StatefulWidget {
  const Modul06PengayaanApp({super.key});

  @override
  State<Modul06PengayaanApp> createState() => _Modul06PengayaanAppState();
}

class _Modul06PengayaanAppState extends State<Modul06PengayaanApp> {
  late final AuthApi _api = const AuthApi();
  late final List<SesiRepository> _repositories = <SesiRepository>[
    AmanSesiRepository(const PenyimpananAmanPlatform()),
    PrefsSesiRepository(),
    MemoriSesiRepository(SesiMemori()),
  ];

  late SesiRepository _repositoryAktif = _repositories.first;
  late final SesiController _controller = SesiController(
    api: _api,
    repository: _repositoryAktif,
  );

  @override
  void initState() {
    super.initState();
    _controller.pulihkan();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _repositories.indexOf(_repositoryAktif),
          onTap: (index) {
            setState(() {
              _repositoryAktif = _repositories[index];
              _controller.gantiRepository(_repositoryAktif);
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Aman'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_open), label: 'Prefs'),
            BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Memori'),
          ],
        ),
        body: GerbangSesi(
          controller: _controller,
          form: (context) => LoginPengayaanScreen(controller: _controller),
          beranda: (context, sesi) => BerandaPengayaanScreen(controller: _controller, sesi: sesi),
        ),
      ),
    );
  }
}