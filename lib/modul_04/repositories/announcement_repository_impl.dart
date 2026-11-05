import 'package:dio/dio.dart';

import '../../../modul_04/models/announcement.dart';
import '../datasources/announcement_remote_datasource.dart';
import 'announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({AnnouncementRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AnnouncementRemoteDataSource();

  final AnnouncementRemoteDataSource _remoteDataSource;

  static const List<String> _kategoriPool = <String>[
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  @override
  Future<List<Announcement>> getAnnouncements({String? category}) async {
    try {
      final rawList = await _remoteDataSource.fetchRawAnnouncements();

      final announcements = rawList.map((item) {
        final id = item['id'] as int;
        final title = item['title'] as String;
        final body = item['body'] as String;
        final cat = _kategoriPool[id % _kategoriPool.length];

        return Announcement(
          id: id,
          title: title,
          content: body,
          category: cat,
          date: '2026-03-${(id % 28 + 1).toString().padLeft(2, '0')}',
          author: 'Bagian Akademik Poliwangi',
          readCount: id * 12,
        );
      }).toList(growable: false);

      if (category != null && category != 'Semua') {
        return announcements
            .where((a) => a.category.toLowerCase() == category.toLowerCase())
            .toList(growable: false);
      }

      return announcements;
    } on DioException catch (e) {
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              'Koneksi ke server timeout. Periksa sambungan internet Anda.';
          break;
        case DioExceptionType.connectionError:
          errorMessage =
              'Gagal terhubung ke server. Periksa koneksi data atau Wi-Fi Anda.';
          break;
        case DioExceptionType.badResponse:
          errorMessage =
              'Server merespons dengan kesalahan (${e.response?.statusCode}).';
          break;
        default:
          errorMessage =
              'Terjadi kendala jaringan: ${e.message ?? 'Kesalahan tidak diketahui'}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga: $e');
    }
  }

  @override
  Future<Announcement> addAnnouncement(Announcement announcement) async {
    try {
      final res = await _remoteDataSource.postRawAnnouncement({
        'title': announcement.title,
        'body': announcement.content,
        'userId': 1,
      });

      // Mengembalikan instance Announcement baru tanpa memanggil copyWith
      return Announcement(
        id: res['id'] as int? ?? 101,
        title: announcement.title,
        content: announcement.content,
        category: announcement.category,
        date: announcement.date,
        author: announcement.author,
        readCount: announcement.readCount,
      );
    } on DioException catch (e) {
      throw Exception('Gagal menambahkan pengumuman: ${e.message}');
    }
  }
}