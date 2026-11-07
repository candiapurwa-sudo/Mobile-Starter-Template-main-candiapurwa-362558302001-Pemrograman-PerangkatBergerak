import 'dart:convert';
import '../../../../modul_06/models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul_06_sesi_aman';
  final PenyimpananAman penyimpanan;

  AmanSesiRepository(this.penyimpanan);

  @override
  String get nama => 'Secure Storage';

  @override
  String get keterangan => 'Menggunakan Keystore/Keychain platform untuk mengenkripsi data.';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final String? raw = await penyimpanan.baca(kunciSesi);
    if (raw == null) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      return SesiPengguna.fromJson(json);
    } catch (_) {
      await hapus();
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    await penyimpanan.tulis(kunciSesi, jsonEncode(sesi.toJson()));
  }

  @override
  Future<void> hapus() => penyimpanan.hapus(kunciSesi);

  @override
  Future<bool> adaSesi() async {
    final String? data = await penyimpanan.baca(kunciSesi);
    return data != null;
  }

  @override
  Future<String?> intipMentah() => penyimpanan.bacaMentah(kunciSesi);
}
