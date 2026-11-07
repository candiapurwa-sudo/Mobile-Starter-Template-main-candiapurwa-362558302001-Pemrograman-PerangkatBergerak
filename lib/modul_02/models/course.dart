// Model data untuk mata kuliah
class Course {
  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final double progress; // progres silabus (0.0 - 1.0)
  final String room;
  final String category;

  const Course({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    required this.progress,
    required this.category,
    this.room = 'Lab Komputer 3',
  });

  // Data dummy untuk bahan praktikum & testing
  static List<Course> getSampleCourses() {
    return const [
      Course(
        code: 'TRPL501',
        name: 'Pemrograman Perangkat Bergerak',
        lecturer: 'Sepyan Purnama Kristanto, S.Kom., M.Kom',
        sks: 4,
        progress: 0.25,
        room: 'Lab TUK',
        category: 'Praktikum',
      ),
      Course(
        code: 'TRPL502',
        name: 'Pemrograman Web Lanjut + Praktikum',
        lecturer: 'Devit Suwardiyanto,S.Si., M.T.',
        sks: 3,
        progress: 0.40,
        room: 'LAB.MULTIMEDIA',
        category: 'Praktikum',
      ),
      Course(
        code: 'TRPL503',
        name: 'Metode dan Model Pengembangan Perangkat',
        lecturer: ' Ruth Ema Febrita, S.Pd., M.Kom',
        sks: 3,
        progress: 0.60,
        room: 'G6.04',
        category: 'Teori',
      ),
      Course(
        code: 'TRPL504',
        name: 'Statistika',
        lecturer: 'Siska Aprilia Hardiyanti, S.Pd., M.Si',
        sks: 2,
        progress: 0.15,
        room: 'G6.02',
        category: 'Teori',
      ),
            Course(
        code: 'TRPL505',
        name: 'Rekayasa Kebutuhan Perangkat Lunak',
        lecturer: 'Eka Novita Sari, S. Kom., M.Kom',
        sks: 2,
        progress: 0.15,
        room: 'G7.10',
        category: 'Teori',
      ),
    ];
  }
}
