import 'package:flutter/material.dart';
import '../models/course.dart';

class HeaderBanner extends StatelessWidget {
  final List<Course>? courses;

  const HeaderBanner({super.key, this.courses});

  // Sample data notifikasi
  final List<Map<String, String>> _notifications = const [
    {
      'title': 'Jadwal Kuliah Diperbarui',
      'body': 'Ruangan Pemrograman Mobile pindah ke Lab 3.',
      'time': '10 mnt lalu',
    },
    {
      'title': 'Tugas Baru Diterbitkan',
      'body': 'Tugas Proyek TRPL501 deadline Jumat ini.',
      'time': '1 jam lalu',
    },
    {
      'title': 'Pengumuman Akademik',
      'body': 'Pengisian KRS semester depan dibuka minggu depan.',
      'time': 'Kemarin',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int totalMatakuliah = courses?.length ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F4C81),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Badge Semester & Fitur Lonceng Notifikasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Semester 3 (2026/2027)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Fitur Lonceng Notifikasi dengan Popup Menu
              PopupMenuButton<int>(
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tooltip: 'Notifikasi',
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                    if (_notifications.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                itemBuilder: (context) {
                  return [
                    // Header Popup Notifikasi
                    const PopupMenuItem<int>(
                      enabled: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notifikasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.mark_email_read_outlined, size: 18, color: Color(0xFF0284C7)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),

                    // Daftar Item Notifikasi
                    ..._notifications.map(
                      (notif) => PopupMenuItem<int>(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  notif['time']!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notif['body']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Teks Ucapan & Nama Mahasiswa
          const Text(
            'Selamat Datang, CANDIA PURWA (362558302001)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Dashboard Akademik & Proyek',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Baris Stats (Jumlah Matakuliah, IPK, % Hadir)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatChip(
                icon: Icons.check_circle_outline,
                label: '$totalMatakuliah Matakuliah',
              ),
              _buildStatChip(
                icon: Icons.star_border,
                label: 'IPK 4.00',
              ),
              _buildStatChip(
                icon: Icons.calendar_today_outlined,
                label: '100% Hadir',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}