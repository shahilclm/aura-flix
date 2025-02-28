import 'dart:ui';

import 'package:auraflixx/Screens/moviedetailpage.dart';
import 'package:auraflixx/Service/movieApi.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../common_widgets/blurcontainer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic>? movieList;

  @override
  void initState() {
    super.initState();
    _fetchTrendingMovie();
  }

  Future<void> _fetchTrendingMovie() async {
    try {
      var response = await MovieApi.getTrendingMovie();
      print(response);
      setState(() {
        movieList = response['results'];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff15141F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  SizedBox(width: 20),
                  Text(
                    'AURAFLIX',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      image: NetworkImage(
                        'https://static1.colliderimages.com/wordpress/wp-content/uploads/2024/08/how-strong-is-spider-man-in-comics-movies-and-beyond.jpg',
                      ),
                      fit: BoxFit.fill,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Trending',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              // Check if movies are loaded
              movieList == null
                  ? const Center(
                      child: CircularProgressIndicator()) // Show loader
                  : CarouselSlider(
                      options: CarouselOptions(
                        height: 400.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayInterval: const Duration(seconds: 4),
                      ),
                      items: movieList!.take(5).map((movie) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailPage(movie: movie),
                            ));
                          },
                          child: Container(
                            width: 50.w,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: Colors.white38,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}',
                                ),
                                fit: BoxFit.cover, // Ensure image fits nicely
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    blurContainer(
                                      width: 92,
                                      height: 64,
                                      borderRadius: 18,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Rating',
                                              style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 19,
                                              ),
                                              Text(
                                                (movie['vote_average'] as num)
                                                    .toStringAsFixed(1),
                                                // Ensures only 2 decimal places
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                ),
                                Spacer(),
                                blurContainer(
                                  height: 91,
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  borderRadius: 24,
                                  child: Center(
                                      child: Text(
                                    '${movie['title']}',
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
