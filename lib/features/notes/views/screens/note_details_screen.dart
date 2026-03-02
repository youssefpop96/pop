import 'package:flutter/material.dart';

class NoteDetailsScreen extends StatelessWidget {
  const NoteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.home_outlined, color: Colors.black54),
            const Icon(Icons.star_outline, color: Colors.black54),
            const Icon(Icons.settings_outlined, color: Colors.black54),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "My Diary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const Icon(Icons.share_outlined),
                ],
              ),
              const SizedBox(height: 32),
              
              // Date
              Row(
                children: [
                  const Icon(Icons.circle, color: Color(0xFF6366F1), size: 10),
                  const SizedBox(width: 10),
                  const Text(
                    "Today, August 25",
                    style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Note Body
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Today was a great day! I completed all my tasks and had a productive meeting with the team. In the evening, I went to the gym and felt great afterwards. Looking forward to tomorrow!",
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Photos Section
              const Text(
                "Photos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPhotoThumbnail("https://picsum.photos/200"),
                  const SizedBox(width: 12),
                  _buildPhotoThumbnail("https://picsum.photos/201"),
                  const SizedBox(width: 12),
                  _buildAddPhotoButton(),
                ],
              ),
              const SizedBox(height: 32),

              // Tags Section
              const Text(
                "Tags",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  _buildTagChip("Personal", const Color(0xFFE0E7FF), const Color(0xFF6366F1)),
                  _buildTagChip("Daily", const Color(0xFFF1F5F9), Colors.black54),
                  _buildTagChip("Life", const Color(0xFFF1F5F9), Colors.black54),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(String url) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6D3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.add, color: Color(0xFFF97316)),
    );
  }

  Widget _buildTagChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
