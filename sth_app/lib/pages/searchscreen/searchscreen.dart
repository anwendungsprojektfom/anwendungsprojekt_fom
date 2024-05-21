import 'package:flutter/material.dart';
import 'package:sth_app/technical/technical.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

// Weiter oben im Code: Import-Anweisungen und Klasse beibehalten

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void performSearch() async {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.startsWith('#')) {
      var results = await searchUsersByHashtags(searchQuery);
      setState(() {
        searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Search'),
        onBack: false,
        showChatIcon: false,
        showSettings: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => performSearch(),
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? const Center(child: Text('No results found.'))
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(searchResults[index]['username']),
                        subtitle:
                            Text(searchResults[index]['hashtags'].join(', ')),
                        onTap: () {
                          Navigator.pushNamed(
                              context, searchResults[index]['profileUrl']);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 1,
      ),
    );
  }
}
