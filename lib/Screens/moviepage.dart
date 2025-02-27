import 'dart:math';
import 'package:auraflixx/Screens/moviedetailpage.dart';
import 'package:auraflixx/Service/movieApi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? movieList;
  List<dynamic>? searchList;
  bool isLoading = true;
  String errorMessage = '';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      var response = await MovieApi.getTrendingMovie();
      setState(() {
        movieList = response['results'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load movies. Please try again.';
        isLoading = false;
      });
    }
  }

  Future<void> _searchMovie() async {
    final String query=_searchController.text.trim();
    try {
      var response = await MovieApi.searchMovie(search:query);
      setState(() {
        searchList = response['results'];
      });
    } catch (e) {
      setState(() {
        searchList = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff15141F),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find Movies, TV Series, and More',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff211F30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: _searchMovie,
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                      onTap: () {

                        _searchController.clear();
                        setState(() {
                          searchList = null;
                        });
                        _fetchMovies();
                      },
                      child: const Icon(Icons.clear, color: Colors.white),
                    )
                        : null,
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: (value) => _searchMovie(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                      color: Colors.red, fontSize: 18),
                ),
              )
                  : searchList != null && searchList!.isNotEmpty
                  ? _buildSearchResults() // Show search results as ListView
                  : _buildTrendingMovies(), // Show trending movies in a grid
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchList!.length,
      itemBuilder: (context, index) {
        var movie = searchList![index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
              'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
              placeholder: (context, url) => Container(
                width: 50,
                height: 75,
                color: Colors.grey[900],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
              width: 50,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            movie['title'] ?? 'No Title',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Rating: ${movie['vote_average']}',
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MovieDetailPage(movie: movie),
            ));
          },
        );
      },
    );
  }

  Widget _buildTrendingMovies() {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: movieList?.length ?? 0,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemBuilder: (context, index) {
        var movie = movieList![index];
        double randomHeight = _random.nextInt(100) + 180;

        return Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movie: movie),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl:
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  placeholder: (context, url) => Container(
                    height: randomHeight,
                    color: Colors.grey[900],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: randomHeight,
                    color: Colors.grey[800],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                  height: randomHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movie['title'] ?? 'No Title',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }
}
