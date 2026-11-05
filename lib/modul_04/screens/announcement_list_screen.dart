import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/announcement_api.dart';
import 'announcement_detail_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key, this.api});

  /// Dapat disuntikkan dari luar (widget test atau demo offline).
  final AnnouncementApi? api;

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  static const List<String> _kategori = <String>[
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  late final AnnouncementApi _api = widget.api ?? AnnouncementApi();
  late Future<List<Announcement>> _futurePengumuman;
  String _kategoriTerpilih = 'Semua';

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  @override
  void dispose() {
    _api.tutup();
    super.dispose();
  }

  Future<void> _muatUlang() async {
    final Future<List<Announcement>> futureBaru = _api.ambilPengumuman();
    setState(() {
      _futurePengumuman = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error sudah ditangani FutureBuilder lewat `snapshot.hasError`.
      // Blok catch ini hanya mencegah "unhandled exception" dan memastikan
      // RefreshIndicator berhenti berputar.
    }
  }

  void _pilihKategori(String kategori) {
    if (kategori == _kategoriTerpilih) return;
    setState(() => _kategoriTerpilih = kategori);
  }

  void _bukaDetail(Announcement announcement) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AnnouncementDetailScreen(announcement: announcement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Portal Pengumuman TRPL'),
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
IconButton(
  icon: const Icon(Icons.refresh),
  tooltip: 'Segarkan Data',
  onPressed: _muatUlang, // Sesuaikan dengan nama fungsi dari Langkah 2
),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Baris filter kategori
          _buildBarisFilter(),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Area konten menggunakan FutureBuilder dengan 4-State
          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _futurePengumuman,
              builder: (context, snapshot) {
                // ── Keadaan 1: LOADING ────────────────────────────────
                if (snapshot.connectionState != ConnectionState.done) {
                  return _buildMemuat();
                }

                // ── Keadaan 2: ERROR ─────────────────────────────────
                if (snapshot.hasError) {
                  return _buildGagal(snapshot.error!);
                }

                // ── Keadaan 3 & 4: KOSONG / BERHASIL ─────────────────
                final List<Announcement> semua =
                    snapshot.data ?? const <Announcement>[];

                final List<Announcement> tampil = _kategoriTerpilih == 'Semua'
                    ? semua
                    : semua
                        .where(
                          (Announcement item) =>
                              item.category.toLowerCase() ==
                              _kategoriTerpilih.toLowerCase(),
                        )
                        .toList(growable: false);

                if (tampil.isEmpty) {
                  return _buildKosong();
                }

                return _buildDaftar(tampil);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Komponen Pembantu UI (Filter & 4-State) ---

  Widget _buildBarisFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _kategori.map((String cat) {
            final bool isSelected = _kategoriTerpilih == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: const Color(0xFFE0F2FE),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF475569),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
                onSelected: (_) => _pilihKategori(cat),
              ),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }

  Widget _buildMemuat() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(color: Color(0xFF0284C7)),
          SizedBox(height: 16),
          Text(
            'Memuat pengumuman dari server...',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildGagal(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString().replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosong() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.inbox_outlined, size: 64, color: Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          Text(
            'Tidak ada pengumuman untuk kategori "$_kategoriTerpilih"',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDaftar(List<Announcement> items) {
    return RefreshIndicator(
      color: const Color(0xFF0284C7),
      onRefresh: _muatUlang,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final Announcement item = items[index];
          return _AnnouncementCard(
            announcement: item,
            onTap: () => _bukaDetail(item),
          );
        },
      ),
    );
  }
}

// Widget kartu pengumuman dengan parameter callback onTap
class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onTap;

  const _AnnouncementCard({
    required this.announcement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Baris tag kategori & tanggal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      announcement.category,
                      style: const TextStyle(
                        color: Color(0xFF0284C7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.access_time, size: 14, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        announcement.date,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Judul pengumuman
              Text(
                announcement.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Cuplikan isi
              Text(
                announcement.content,
                style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Penulis & jumlah pembaca
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    announcement.author,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.remove_red_eye_outlined, size: 14, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        '${announcement.readCount}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}