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
  List<dynamic> searchResults = [];
  final TextEditingController _controller = TextEditingController();

  int page = 0;

  Future<List<dynamic>> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/shows?page=$page'));
    // await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // print(data.map((item) => item).toList());
      return data.map((item) => item).toList(); // Extracting the show data
    } else {
      throw Exception('Failed to load movies');
    }
  }

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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Home",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      searchResults = [];
                    });
                  }
                  Future.delayed(const Duration(seconds: 1), () {
                    searchMovies(_controller.text);
                  });
                },
                // onTapOutside: , remove focus
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIconColor: Colors.black,
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchMovies(_controller.text);
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  fillColor: Colors.white38,
                  filled: true,
                ),
              ),
              Expanded(
                child: searchResults.isEmpty
                    ? _controller.text.isEmpty
                        ? const Center(child: Text("Search"))
                        : const Center(child: Text('No results found'))
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
                                  : 'https://static.tvmaze.com/images/no-img/no-img-portrait-text.png',
                              width: 50,
                              height: 75,
                              fit: BoxFit.contain,
                            ),
                            title: Text(
                                "${show['name']} ${show['premiered'] != null ? '(${show['premiered'].split("-").first})' : ''}"),
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
      ),
    );
  }
}
