import '../../../modul_04/models/announcement.dart';

// ── KONTRAK REPOSITORY (Interface / Abstract Class) ──
abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements({String? category});
  Future<Announcement> addAnnouncement(Announcement announcement);
}

// ── IMPLEMENTASI SAMPLE / OFFLINE DATA ──
class SampleAnnouncementRepository implements AnnouncementRepository {
  /// Menggunakan List.of(...) agar list sample dapat dimodifikasi (tidak unmodifiable)
  final List<Announcement> _items =
      List<Announcement>.of(Announcement.getSampleAnnouncements());

  @override
  Future<List<Announcement>> getAnnouncements({String? category}) async {
    // Simulasi latensi lokal
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (category != null && category != 'Semua') {
      return _items
          .where((item) => item.category.toLowerCase() == category.toLowerCase())
          .toList(growable: false);
    }

    return List<Announcement>.unmodifiable(_items);
  }

  @override
  Future<Announcement> addAnnouncement(Announcement announcement) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    
    // Membuat objek Announcement baru secara langsung tanpa copyWith
    final baru = Announcement(
      id: _items.length + 1,
      title: announcement.title,
      content: announcement.content,
      category: announcement.category,
      date: announcement.date,
      author: announcement.author,
      readCount: announcement.readCount,
    );
    
    _items.insert(0, baru);
    return baru;
  }
}