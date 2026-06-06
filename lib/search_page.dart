import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allData = [
    {
      "name": "Alexander Ray",
      "type": "User",
      "img": "https://randomuser.me/api/portraits/men/5.jpg",
    },
    {
      "name": "Luna Sterling",
      "type": "User",
      "img": "https://randomuser.me/api/portraits/women/4.jpg",
    },
    {
      "name": "Elena Smith",
      "type": "User",
      "img": "https://randomuser.me/api/portraits/women/1.jpg",
    },
    {
      "name": "Nebula Photography",
      "type": "Post",
      "img":
          "https://images.unsplash.com/photo-1464802686167-b939a6910659?w=100",
    },
    {
      "name": "Minimalist Workspace",
      "type": "Post",
      "img":
          "https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=100",
    },
  ];

  List<Map<String, String>> _searchResults = [];

  @override
  void initState() {
    _searchResults = _allData;
    super.initState();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchResults = _allData
          .where(
            (item) => item['name']!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF6B46C0),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            autofocus: true,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search for people or posts...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF6B46C0),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Recent Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      return _buildResultTile(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(item['img']!),
        ),
        title: Text(
          item['name']!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF0B1C30),
          ),
        ),
        subtitle: Text(
          item['type']!,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: const Icon(Icons.north_west, size: 18, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Text(
            'No results found for "${_searchController.text}"',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
