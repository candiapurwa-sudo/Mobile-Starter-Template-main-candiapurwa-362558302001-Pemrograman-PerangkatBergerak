import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement.dart';
import '../repositories/announcement_repository.dart';
import '../repositories/announcement_repository_impl.dart';

// ── 1. Provider Sakelar Data (Sample / API Nyata) ──
/// Membaca flag dari terminal: flutter run --dart-define=USE_SAMPLE_DATA=true
final useSampleDataProvider = Provider<bool>((ref) {
  return const bool.fromEnvironment('USE_SAMPLE_DATA', defaultValue: false);
});

// ── 2. Provider Instance Repository ──
/// Otomatis memilih SampleAnnouncementRepository jika flag true,
/// atau AnnouncementRepositoryImpl (Dio) jika flag false
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  final bool useSample = ref.watch(useSampleDataProvider);
  if (useSample) {
    return SampleAnnouncementRepository();
  }
  return AnnouncementRepositoryImpl();
});

// ── 3. Notifier & Provider Kategori Filter ──
/// Mengelola status kategori terpilih secara modern dengan Notifier
class SelectedCategory extends Notifier<String> {
  @override
  String build() => 'Semua';

  void select(String value) => state = value;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategory, String>(SelectedCategory.new);

// ── 4. FutureProvider Daftar Pengumuman ──
/// Otomatis menghitung ulang data ketika repository atau kategori berganti.
/// Menyediakan 4-state (AsyncValue): loading, data, error, kosong.
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);

  return repository.getAnnouncements(category: category);
});