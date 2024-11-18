import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailsScreen extends StatelessWidget {
  final int showId;

  const MovieDetailsScreen({super.key, required this.showId});

  Future<Map<String, dynamic>> fetchMovieDetails() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/shows/$showId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final show = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: show['image'] != null
                          ? show['image']['original']
                          : 'https://static.tvmaze.com/images/no-img/no-img-portrait-text.png',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    show['name'] ?? "",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    show['genres'].join(', ') ?? "",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  if (show['premiered'] != null) ...[
                    Text(
                      'Premiered: ${show['premiered'] ?? ""}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (show['status'] != null) ...[
                    Text(
                      'Status: ${show['status'] ?? ""}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    //   ],
                    // ),
                    const SizedBox(height: 16),
                  ],

                  // Show Runtime
                  if (show['runtime'] != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '${show['runtime']} minutes',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16)
                  ],

                  // Show Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Rating: ${show['rating']['average'] ?? 'N/A'} / 10',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Show Network
                  if (show['network'] != null &&
                      show['network']['name'] != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.tv, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Network: ${show['network']['name'] ?? ""}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16)
                  ],

                  // Summary
                  if (show['summary'] != null) ...[
                    const Text(
                      'Summary',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      show['summary'] != null
                          ? show['summary']?.replaceAll(RegExp(r'<[^>]*>'), '')
                          : 'No summary available.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
