import 'package:flutter/material.dart';
import '../../../../modul_06/models/sesi_pengguna.dart';
import '../../../../modul_06/widgets/kartu_sesi.dart';
import '../controllers/sesi_controller.dart';
import '../widgets/papan_diagnostik_penyimpanan.dart';

class BerandaPengayaanScreen extends StatelessWidget {
  final SesiController controller;
  final SesiPengguna sesi;

  const BerandaPengayaanScreen({
    super.key,
    required this.controller,
    required this.sesi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Pengayaan'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Perbarui Token',
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.perbaruiSesi(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          KartuSesi(
            sesi: sesi,
            sekarang: controller.jam(),
            onKeluar: () => controller.keluar(),
          ),
          const SizedBox(height: 20),
          PapanDiagnostikPenyimpanan(repository: controller.repository),
        ],
      ),
    );
  }
}