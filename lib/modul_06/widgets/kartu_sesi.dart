import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;
  final bool sedangKeluar;
  final bool tampilkanToken;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
    this.tampilkanToken = false,
  });

  static String samarkanToken(String token) {
    if (token.isEmpty) return '(kosong)';
    if (token.length <= 6) return _titik(token.length);
    return '${token.substring(0, 6)}${_titik(12)}';
  }

  static String _titik(int jumlah) => List<String>.filled(jumlah, '\u2022').join();

  static String formatWaktu(String iso) {
    const List<String> bulan = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final DateTime? waktu = DateTime.tryParse(iso);
    if (waktu == null) return 'tidak diketahui';
    final String jam = waktu.hour.toString().padLeft(2, '0');
    final String menit = waktu.minute.toString().padLeft(2, '0');
    return '${waktu.day} ${bulan[waktu.month - 1]} ${waktu.year}, $jam:$menit';
  }

  static String formatSisa(Duration sisa) {
    if (sisa.inSeconds <= 0) return 'sudah berakhir';
    if (sisa.inMinutes < 1) return '${sisa.inSeconds} detik';
    if (sisa.inHours < 1) return '${sisa.inMinutes} menit';
    final int menit = sisa.inMinutes.remainder(60);
    return menit == 0 ? '${sisa.inHours} jam' : '${sisa.inHours} jam $menit menit';
  }

  @override
  Widget build(BuildContext context) {
    final Duration sisa = sesi.sisaWaktu(sekarang);
    final ThemeData tema = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sesi.nama, style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text(sesi.email, style: tema.textTheme.bodyMedium?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
            const Divider(height: 24),
            _barisInfo('Peran', SesiPengguna.labelPeran(sesi.peran)),
            _barisInfo('Waktu Masuk', formatWaktu(sesi.masukPada)),
            _barisInfo('Sisa Masa Aktif', formatSisa(sisa)),
            _barisInfo('Token', tampilkanToken ? sesi.token : samarkanToken(sesi.token)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: sedangKeluar ? null : onKeluar,
                icon: sedangKeluar
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.logout_rounded),
                label: Text(sedangKeluar ? 'Memproses...' : 'Keluar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisInfo(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(judul, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(child: Text(isi, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}