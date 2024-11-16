import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final http.Response response;
    if (_controller.text.isNotEmpty) {
      response = await http.get(Uri.parse(
          'https://api.tvmaze.com/search/shows?q=${_controller.text}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item['show']).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } else {
      response =
          await http.get(Uri.parse('https://api.tvmaze.com/shows?page=$page'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item).toList();
      } else {
        throw Exception('Failed to load movies');
      }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 600 ? 3 : 2; // Adjusts columns based on screen width
    final childAspectRatio =
        (screenWidth / crossAxisCount) / (screenWidth / crossAxisCount * 1.6);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Home",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                onChanged: (value) {
                  // if (value.isEmpty) {
                  //   setState(() {
                  //     searchResults = [];
                  //   });
                  // }
                  // Future.delayed(const Duration(seconds: 1), () {
                  //   // searchMovies(_controller.text);
                  // });
                },
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
                      // searchMovies(_controller.text);
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
                child: FutureBuilder<List<dynamic>>(
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

                    searchResults = snapshot.data!;
                    // print(movies.length);
                    // print("length : ${movies.length}");

                    return ListView.builder(
                      // padding: const EdgeInsets.all(8.0),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = searchResults[index];
                        // print(movie);
                        final imageUrl = movie['image'] != null
                            ? movie['image']['medium']
                            : 'https://static.tvmaze.com/images/no-img/no-img-portrait-text.png';
                        final title = movie['name'];
                        // final summary =
                        //     movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                        //         'No summary available.';
                        final gerne = movie['genres'];
                        final rating = movie['rating']['average'];

                        return Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the details screen for this movie
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(
                                    showId: movie['id'],
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 140,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        // offset: const Offset(0, 5),
                                        // top 0 right 5
                                        offset: const Offset(0.1, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: -60,
                                  left: 10,
                                  child: Container(
                                    width: 120,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  left: 150,
                                  right: 16,
                                  bottom: 20,
                                  child: SizedBox.shrink(
                                    // height: 180,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          gerne.join(' | '),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (rating != null) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 18,
                                              // vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: rating != null
                                                  ? rating >= 7
                                                      ? Colors.green
                                                      : rating >= 5
                                                          ? Colors.blue
                                                          : Colors.red
                                                  : Colors.grey,
                                            ),
                                            child: Text(
                                              "$rating IMDB",
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        // return Column(
                        //   children: [
                        //     const SizedBox(height: 90),
                        //     GestureDetector(
                        //       onTap: () {
                        //         // Navigate to the details screen for this movie
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => MovieDetailsScreen(
                        //               showId: movie['id'],
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //       child: Stack(
                        //         clipBehavior: Clip.none,
                        //         children: [
                        //           Container(
                        //             height: 140,
                        //             padding: const EdgeInsets.all(16),
                        //             decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.circular(8),
                        //               boxShadow: [
                        //                 BoxShadow(
                        //                   color: Colors.black.withOpacity(0.1),
                        //                   blurRadius: 10,
                        //                   // offset: const Offset(0, 5),
                        //                   // top 0 right 5
                        //                   offset: const Offset(0.1, 2),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           Positioned(
                        //             top: -60,
                        //             left: 10,
                        //             child: Container(
                        //               width: 120,
                        //               height: 180,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(8),
                        //                 image: DecorationImage(
                        //                   image: NetworkImage(
                        //                     imageUrl,
                        //                   ),
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Positioned(
                        //             top: 16,
                        //             left: 150,
                        //             right: 16,
                        //             bottom: 20,
                        //             child: SizedBox.shrink(
                        //               // height: 180,
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     title,
                        //                     style: const TextStyle(
                        //                       fontSize: 17,
                        //                       fontWeight: FontWeight.bold,
                        //                       overflow: TextOverflow.ellipsis,
                        //                     ),
                        //                   ),
                        //                   const SizedBox(height: 8),
                        //                   Text(
                        //                     gerne.join(' | '),
                        //                     style: const TextStyle(
                        //                       fontSize: 13,
                        //                       color: Colors.grey,
                        //                     ),
                        //                   ),
                        //                   const SizedBox(height: 8),
                        //                   Container(
                        //                     padding: const EdgeInsets.symmetric(
                        //                       horizontal: 18,
                        //                       // vertical: 2,
                        //                     ),
                        //                     decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(50),
                        //                       color: rating != null
                        //                           ? rating >= 7
                        //                               ? Colors.green
                        //                               : rating >= 5
                        //                                   ? Colors.blue
                        //                                   : Colors.red
                        //                           : Colors.grey,
                        //                     ),
                        //                     child: Text(
                        //                       "$rating IMDB",
                        //                       maxLines: 2,
                        //                       style: const TextStyle(
                        //                         fontSize: 13,
                        //                         color: Colors.white,
                        //                         overflow: TextOverflow.ellipsis,
                        //                         fontWeight: FontWeight.w400,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     const SizedBox(height: 90),
                        //   ],
                        // );
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
