import 'package:flutter/foundation.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';



enum StatusSesi { memeriksa, keluar, memproses, masuk, gagal, kedaluwarsa }

class SesiController extends ChangeNotifier {
  final AuthApi api;
  final DateTime Function() jam;
  SesiRepository _repository;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesan;

  SesiController({
    required this.api,
    required SesiRepository repository,
    this.jam = DateTime.now,
  }) : _repository = repository;

  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesan => _pesan;
  SesiRepository get repository => _repository;

  void gantiRepository(SesiRepository repoBaru) {
    if (_repository == repoBaru) return;
    _repository = repoBaru;
    pulihkan();
  }

  void _ubah(StatusSesi baru, {SesiPengguna? sesi, String? pesan, bool bersihkanPesan = false}) {
    _status = baru;
    _sesi = sesi ?? _sesi;
    if (bersihkanPesan) {
      _pesan = null;
    } else if (pesan != null) {
      _pesan = pesan;
    }
    notifyListeners();
  }

  Future<void> pulihkan() async {
    _ubah(StatusSesi.memeriksa, bersihkanPesan: true);
    final SesiPengguna? tersimpan = await _repository.baca();
    if (tersimpan == null) {
      _ubah(StatusSesi.keluar, sesi: null);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(jam())) {
      await _repository.hapus();
      _sesi = null;
      _ubah(StatusSesi.kedaluwarsa, pesan: 'Sesi Anda sudah berakhir. Silakan masuk kembali.');
      return;
    }

    _ubah(StatusSesi.masuk, sesi: tersimpan);
  }

  Future<void> masuk({required String email, required String sandi}) async {
    if (_status == StatusSesi.memproses) return;
    _ubah(StatusSesi.memproses, bersihkanPesan: true);

    try {
      final SesiPengguna hasil = await api.masuk(email: email, sandi: sandi);
      await _repository.simpan(hasil);
      _ubah(StatusSesi.masuk, sesi: hasil);
    } on AuthException catch (e) {
      _ubah(StatusSesi.gagal, pesan: e.pesan);
    } catch (_) {
      _ubah(StatusSesi.gagal, pesan: 'Terjadi kesalahan tak terduga. Coba lagi.');
    }
  }

  Future<void> keluar() async {
    await _repository.hapus();
    _sesi = null;
    _ubah(StatusSesi.keluar, bersihkanPesan: true);
  }

  Future<void> perbaruiSesi({Duration masaBerlaku = const Duration(hours: 2)}) async {
    final SesiPengguna? sekarang = _sesi;
    if (sekarang == null) return;

    if (sekarang.sudahKedaluwarsa(jam())) {
      await _repository.hapus();
      _sesi = null;
      _ubah(StatusSesi.kedaluwarsa, pesan: 'Sesi sudah berakhir dan tidak dapat diperbarui.');
      return;
    }

    final SesiPengguna baru = await api.perbaruiSesi(sekarang, masaBerlaku: masaBerlaku);
    await _repository.simpan(baru);
    _ubah(StatusSesi.masuk, sesi: baru);
  }
}
