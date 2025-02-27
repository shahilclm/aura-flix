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
  List<dynamic>? movieList;
  bool isLoading = true;
  String errorMessage = '';

  final Random _random = Random(); // To generate random heights

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
                  style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w500),
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
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
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
                  : MasonryGridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: movieList?.length ?? 0,
                crossAxisCount: 2, // 2 columns
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (context, index) {
                  var movie = movieList![index];

                  // Generate a random height for staggered effect
                  double randomHeight = _random.nextInt(100) + 180; // Height between 180-280

                  return Column(
                    children: [
                      GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailPage(movie: movie),)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                            placeholder: (context, url) => Container(
                              height: randomHeight,
                              color: Colors.grey[900],
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                Container(height: randomHeight, color: Colors.grey[800], child: const Icon(Icons.error, color: Colors.red)),
                            height: randomHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text('${movie['title']}',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
                      const SizedBox(height: 5,),
                    ],
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
