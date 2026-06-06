import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 30, right: 30),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIcon(Icons.home, 0),
          _buildIcon(Icons.explore_outlined, 1),

          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6B46C0), Color(0xFF8E5EFF)],
                ),
              ),
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),

          _buildIcon(Icons.chat_bubble_outline, 3),
          _buildIcon(Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        color: isActive ? const Color(0xFF6B46C0) : Colors.grey,
      ),
    );
  }
}
