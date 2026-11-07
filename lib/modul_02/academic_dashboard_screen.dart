import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({super.key});

  @override
  State<AcademicDashboardScreen> createState() => _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState extends State<AcademicDashboardScreen> {
  final List<Course> _courses = Course.getSampleCourses();
  bool _isDarkMode = false;
  String _selectedCategory = 'Semua';

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'Semua') {
      return _courses;
    }
    return _courses.where((course) {
      return course.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Widget _buildFilterChips() {
    final categories = ['Semua', 'Teori', 'Praktikum'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              showCheckmark: isSelected,
              label: Text(category),
              selected: isSelected,
              selectedColor: const Color(0xFFCFE2FE),
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: isSelected ? const Color(0xFF0284C7) : Colors.grey.shade400,
              ),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF0369A1) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  _onCategorySelected(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalSks = _courses.fold(0, (sum, c) => sum + c.sks);

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          title: const Text(
            'Dashboard Akademik TRPL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                HeaderBanner(courses: _courses),
                const SizedBox(height: 20),

                // Title + Total SKS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Mata Kuliah (${_courses.length} Terdaftar)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total SKS: $totalSks',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter Buttons
                _buildFilterChips(),
                const SizedBox(height: 16),

                // Layout Adaptif:
                // Tablet (>= 600dp): GridView 2 Kolom dengan childAspectRatio 1.4 (bebas overflow)
                // Mobile (< 600dp): Daftar Card Langsung
                if (isTablet)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: _filteredCourses[index]);
                    },
                  )
                else
                  ..._filteredCourses.map((course) => CourseCard(course: course)),
              ],
            );
          },
        ),
      ),
    );
  }
}