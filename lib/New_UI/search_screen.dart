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
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search Movies & Tv Shows...',
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
                suffixIconColor: Colors.white,
                suffixIcon: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchMovies(_controller.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromRGBO(60, 148, 139, 1),
                    ),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        side: BorderSide(
                          color: Color.fromRGBO(60, 148, 139, 0),
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(60, 148, 139, 1),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(60, 148, 139, 1),
                  ),
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
                      ? const Center(child: Text("Search Movie & TV Shows..."))
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
    );
  }
}
