import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sth_app/technical/technical.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  Future<void> fetchUserSearchResults(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      List<Map<String, dynamic>> results = await searchUsers(searchTerm);
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
              onChanged: fetchUserSearchResults,
              decoration: const InputDecoration(
                hintText: 'Search profile name or hashtag.....',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final userData = searchResults[index];
                final userId = userData['userId'];
                final name = userData['name'];
                final email = userData['email'];
                final phoneNumber = userData['phone'];
                final address = userData['address'];
                final hashtags = (userData['selectedHashtags'] as List).join(', ');

                return Card(
                  child: ListTile(
                    leading: FutureBuilder<List<String>>(
                      future: downloadAvatarFromFirebase(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircleAvatar(
                            radius: 25,
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.error),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: MemoryImage(
                              base64Decode(snapshot.data![0]),
                            ),
                          );
                        } else {
                          return const CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.account_circle, size: 50),
                          );
                        }
                      },
                    ),
                    title: Text('Name: $name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: $email'),
                        Text('Phone Number: $phoneNumber'),
                        Text('Address: $address'),
                        Text('Hashtags: $hashtags'),
                      ],
                    ),
                    onTap: () {},
                  ),
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
