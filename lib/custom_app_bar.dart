import 'package:flutter/material.dart';
import 'search_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 10,
      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Image.asset('assets/logo.png', height: 80, fit: BoxFit.contain),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
              size: 28,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.black87, size: 28),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
