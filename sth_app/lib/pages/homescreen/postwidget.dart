import 'dart:convert';

import 'package:flutter/material.dart';
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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Choose the color of the border
                    width: 2.0, // Choose the width of the border
                  ),
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/Images/logoSTH.png'),
                ),
              ),
              const SizedBox(width: 8.0),
              _buildPostWidget(),
            ],
          ),
          const SizedBox(height: 8.0),
          FutureBuilder<List<String>>(
            future: downloadImagesFromFirebase('JN2dcl4RbBNSs7VGEbYZ'), // Replace 'secondAccountID' with actual ID
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
                  height: 200, // Set a fixed height for the PageView
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

  Widget _buildPostWidget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Jonas", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
