import 'package:flutter/material.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  const Text(
                    "Add New Note",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balancing back button
                ],
              ),
              const SizedBox(height: 32),

              // Title Field
              const Text("Title:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildTextField("Enter note title...", maxLines: 1),
              const SizedBox(height: 24),

              // Content Field
              const Text("Content:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildTextField("Start typing your note...", maxLines: 8),
              const SizedBox(height: 24),

              // Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.format_bold, color: Colors.black54),
                    const Icon(Icons.format_italic, color: Colors.black54),
                    const Icon(Icons.format_underlined, color: Colors.black54),
                    const Icon(Icons.format_align_left, color: Colors.black54),
                    const Icon(Icons.format_list_bulleted, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Folder Selection
              const Text("Folder:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: "Personal",
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ["Personal", "Work", "Study", "Ideas"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tags
              const Text("Tags:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildTextField("Add tag...", maxLines: 1),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  _buildTagChip("Personal", const Color(0xFFE0E7FF), const Color(0xFF6366F1), true),
                  _buildTagChip("Important", const Color(0xFFFFE6D3), const Color(0xFFF97316), true),
                ],
              ),
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: const Color(0xFF6366F1).withOpacity(0.5),
                  ),
                  child: const Text(
                    "Save Note",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildTagChip(String label, Color bgColor, Color textColor, bool showRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          if (showRemove) ...[
            const SizedBox(width: 8),
            Icon(Icons.close, size: 14, color: textColor),
          ],
        ],
      ),
    );
  }
}
