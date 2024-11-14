import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/MovieDetails_Screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> searchMovies(String query) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = data;
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onEditingComplete: () {
                searchMovies(_controller.text);
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search Movies...',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                suffixIconColor: Colors.white,
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(60, 148, 139, 1),
                  ),
                ),
                fillColor: Colors.white38,
                filled: true,
              ),
            ),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        var show = searchResults[index]['show'];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          leading: CachedNetworkImage(
                            imageUrl: show['image'] != null
                                ? show['image']['medium']
                                : 'https://via.placeholder.com/150',
                            width: 50,
                            height: 75,
                            fit: BoxFit.contain,
                          ),
                          title: Text(show['name']),
                          // subtitle: Text(
                          //   show['summary']
                          //           ?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                          //       'No description available',
                          //   maxLines: 1,
                          // ),
                          // gerne join
                          subtitle: Text(
                            show['genres'].join(', '),
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsScreen(showId: show['id']),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
