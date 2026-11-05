import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul_06_sesi_pengguna';

  @override
  String get nama => 'SharedPreferences';

  @override
  String get keterangan => 'Bertahan di disk, tetapi data tersimpan dalam bentuk teks biasa.';

  @override
  bool get bertahanSetelahRestart => true;

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<SesiPengguna?> baca() async {
    final SharedPreferences prefs = await _prefs;
    final String? raw = prefs.getString(kunciSesi);
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
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(kunciSesi, jsonEncode(sesi.toJson()));
  }

  @override
  Future<void> hapus() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey(kunciSesi);
  }

  @override
  Future<String?> intipMentah() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(kunciSesi);
  }
}