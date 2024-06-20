import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sth_app/technical/firebase_tools/firebase_tools.dart';
import 'package:sth_app/technical/technical.dart';

class PostWidget extends StatelessWidget {
  final String userId;

  const PostWidget({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder<List<String>>(
                future: downloadAvatarFromFirebase(userId),
                builder: (context, snapshot) {
                  Widget avatar;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    avatar = const CircleAvatar(
                      radius: 20,
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    avatar = const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.error),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    avatar = CircleAvatar(
                      radius: 20,
                      backgroundImage: MemoryImage(
                        base64Decode(snapshot.data![0]),
                      ),
                    );
                  } else {
                    avatar = const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: avatar,
                  );
                },
              ),
              const SizedBox(width: 8.0),
              FutureBuilder<String?>(
                future: getCurrentUserName(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading username');
                  } else if (snapshot.hasData) {
                    return Text(snapshot.data ?? 'No username found');
                  } else {
                    return const Text('No username found');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          FutureBuilder<List<String>>(
            future: downloadImagesFromFirebase(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Error loading images'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Image.memory(
                        base64Decode(snapshot.data![index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No image data found'),
                );
              }
            },
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 4.0),
              Icon(Icons.comment),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostWidget(String? name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name ?? '', // Provide a default value in case name is null
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
