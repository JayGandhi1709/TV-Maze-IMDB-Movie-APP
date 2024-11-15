import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/MovieDetails_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  Future<List<dynamic>> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/shows?page=$page'));
    // await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => item['show'])
          .toList(); // Extracting the show data
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies & TV Shows'),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Movies Found.'));
          }

          final movies = snapshot.data!;

          return Column(
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.6,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final imageUrl = movie['image'] != null
                      ? movie['image']['medium']
                      : 'https://static.tvmaze.com/images/no-img/no-img-portrait-text.png';
                  // : 'https://via.placeholder.com/200x300';
                  final title = movie['name'];
                  final summary =
                      movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                          'No summary available.';

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the details screen for this movie
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailsScreen(showId: movie['id']),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Movie Title
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                // Short Summary (truncated)
                                Text(
                                  summary.length > 100
                                      ? summary.substring(0, 100) + '...'
                                      : summary,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // show next page button
              if (page > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      page--;
                    });
                    fetchMovies();
                  },
                  child: const Text('<< Previous'),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    page++;
                  });
                  fetchMovies();
                },
                child: const Text('Next >>'),
              ),
            ],
          );
        },
      ),
    );
  }
}
