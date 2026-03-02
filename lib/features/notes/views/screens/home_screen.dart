import 'package:flutter/material.dart';
import '../../models/folder_model.dart';
import '../../models/note_model.dart';
import '../widgets/folder_card.dart';
import '../widgets/recent_note_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data for folders (Screen 1 colors/icons)
    final List<FolderModel> folders = [
      FolderModel(
        title: "Personal",
        notesCount: 12,
        icon: Icons.folder_open_outlined,
        gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      ),
      FolderModel(
        title: "Work",
        notesCount: 8,
        icon: Icons.work_outline,
        gradientColors: [const Color(0xFF10B981), const Color(0xFF059669)],
      ),
      FolderModel(
        title: "Study",
        notesCount: 15,
        icon: Icons.school_outlined,
        gradientColors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      ),
      FolderModel(
        title: "Ideas",
        notesCount: 6,
        icon: Icons.lightbulb_outline,
        gradientColors: [const Color(0xFFEF4444), const Color(0xFFB91C1C)],
      ),
    ];

    // Fake data for recent notes
    final List<NoteModel> recentNotes = [
      NoteModel(
        title: "Shopping List",
        folder: "Personal",
        time: "Today, 10:30 AM",
        categoryColor: const Color(0xFF6366F1),
        icon: Icons.folder_open_outlined,
      ),
      NoteModel(
        title: "Meeting Summary",
        folder: "Work",
        time: "Yesterday",
        categoryColor: const Color(0xFF10B981),
        icon: Icons.work_outline,
      ),
      NoteModel(
        title: "Lecture 5",
        folder: "Study",
        time: "2 days ago",
        categoryColor: const Color(0xFFF59E0B),
        icon: Icons.school_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light off-white background
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar (Menu, Title, Notification)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.black87),
                  const Text(
                    "My Folders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(Icons.notifications_outlined, color: Colors.black87),
                ],
              ),
              const SizedBox(height: 32),
              
              // Search Bar (with Mic icon)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.black38),
                    suffixIcon: const Icon(Icons.mic_none_outlined, color: Colors.black38),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Create New Folder Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, color: Color(0xFF6366F1), size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Create New Folder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Folders Grid (Personal, Work, etc.)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.0,
                ),
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  return FolderCard(folder: folders[index]);
                },
              ),
              const SizedBox(height: 48),

              // Recent Notes Header (View All)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Notes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recent Notes List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentNotes.length,
                itemBuilder: (context, index) {
                  return RecentNoteItem(note: recentNotes[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
