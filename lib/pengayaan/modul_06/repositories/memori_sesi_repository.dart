import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../../modul_06/services/sesi_memori.dart';
import 'sesi_repository.dart';

class MemoriSesiRepository implements SesiRepository {
  final SesiMemori memori;

  MemoriSesiRepository(this.memori);

  @override
  String get nama => 'Memori (RAM)';

  @override
  String get keterangan => 'Hanya ada di memori proses, hilang saat proses berakhir.';

  @override
  bool get bertahanSetelahRestart => false;

  @override
  Future<SesiPengguna?> baca() async => memori.baca();

  @override
  Future<void> simpan(SesiPengguna sesi) => memori.simpan(sesi);

  @override
  Future<void> hapus() => memori.hapus();

  @override
  Future<bool> adaSesi() async => memori.adaSesi;

  @override
  Future<String?> intipMentah() async => null;
}
