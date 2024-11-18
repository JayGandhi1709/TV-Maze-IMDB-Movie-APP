import 'package:flutter/material.dart';
import 'package:myapp/Movie_Details_Screen.dart';
import 'package:provider/provider.dart';
import 'movie_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  Provider.of<MovieProvider>(context, listen: false)
                      .fetchMovies(query: value);
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
                      Provider.of<MovieProvider>(context, listen: false)
                          .fetchMovies(query: _controller.text);
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
              if (movieProvider.isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else if (movieProvider.errorMessage.isNotEmpty)
                Center(child: Text(movieProvider.errorMessage))
              else
                Expanded(
                  child: ListView.builder(
                    // padding: const EdgeInsets.all(8.0),
                    itemCount: movieProvider.movies.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.movies[index];
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
