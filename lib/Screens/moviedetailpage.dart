import 'package:auraflixx/Service/movieApi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class MovieDetailPage extends StatefulWidget {
  final Map<String, dynamic> movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  List<dynamic> relatedmovie = [];
  Map<String, dynamic> detailsMovie = {};

  @override
  void initState() {
    _relatedMovie();
    _detailsMovie();
    // TODO: implement initState
    super.initState();
  }

//similar movie
  Future<void> _relatedMovie() async {
    try {
      var response = await MovieApi.getRelatedMovie(id: widget.movie['id']);
      print(response);
      setState(() {
        relatedmovie = response['results'];
      });
    } catch (e) {
      print('error$e');
    }
  }

  //details movie
  Future<void> _detailsMovie() async {
    try {
      var response = await MovieApi.detailsMovie(id: widget.movie['id']);
      setState(() {
        detailsMovie = response;
      });
    } catch (e) {
      print('error$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff15141F),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              CachedNetworkImage(
                imageUrl: detailsMovie['backdrop_path'] != null &&
                        detailsMovie['backdrop_path'] != ''
                    ? 'https://image.tmdb.org/t/p/w500${detailsMovie['backdrop_path']}'
                    : 'https://via.placeholder.com/500x300.png?text=No+Image',
                // Placeholder image URL
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Colors.grey[900],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 400,
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
                height: 400,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        )),
                  )
                ],
              )
            ]),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                '${detailsMovie['title']}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20,),
                Icon(Icons.access_time_outlined,color: Colors.grey,),
                SizedBox(width: 10,),
                Text('${detailsMovie['runtime']} minutes',style: TextStyle(color: Colors.grey),),
SizedBox(width: 30,),
                Icon(
                  Icons.star,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${(widget.movie['vote_average'] as num).toStringAsFixed(1)}  (IMDb)',
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              thickness: .5,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Release date',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${detailsMovie['release_date']}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Genre',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Row(children: [
                      if (detailsMovie['genres'] != null &&
                          detailsMovie['genres'].isNotEmpty)
                        _genreChip(detailsMovie['genres'][0]['name']),
                      SizedBox(width: 10),
                      if (detailsMovie['genres'] != null &&
                          detailsMovie['genres'].length > 1)
                        _genreChip(detailsMovie['genres'][1]['name']),
                    ]),
                  ],
                ),
                SizedBox(
                  width: 25,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              thickness: .5,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Synopsis',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5, right: 20),
              child: ReadMoreText(
                '${detailsMovie['overview']}',
                style: TextStyle(color: Colors.grey),
                trimLines: 3,
                trimMode: TrimMode.Line,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
              child: Text(
                'Related Movie',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 250, // Define height for the ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedmovie.length > 8 ? 8 : relatedmovie.length,
                itemBuilder: (context, index) {
                  var similarmovie = relatedmovie[index];
                  return Column(
                    children: [
                      Container(
                        width: 180,
                        height: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${similarmovie['poster_path']}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 100,
                              color: Colors.grey[900],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                                height: 100,
                                color: Colors.grey[800],
                                child:
                                    const Icon(Icons.error, color: Colors.red)),
                          ),
                        ), // Optional spacing between items
                      ),
                      Text(
                        '${similarmovie['title']}',
                        style: TextStyle(color: Colors.white),
                      )
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

  Widget _genreChip(String genreName) {
    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff201f27),
      ),
      child: Center(
        child: Text(
          genreName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
