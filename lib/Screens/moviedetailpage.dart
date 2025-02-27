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

  @override
  void initState() {
    _relatedMovie();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _relatedMovie() async {
    try {
      var response = await MovieApi.getRelatedMovie(id: widget.movie['id']);
      print(response);
      setState(() {
        relatedmovie = response['results'];
      });
    } catch (e) {}
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
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${widget.movie['backdrop_path']}',
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Colors.grey[900],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                    height: 400,
                    color: Colors.grey[800],
                    child: const Icon(Icons.error, color: Colors.red)),
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
                '${widget.movie['title']}',
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

              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              thickness: .1,
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
                    Text(
                      '${widget.movie['release_date']}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              thickness: .1,
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
                '${widget.movie['overview']}',
                style: TextStyle(color: Colors.grey),
                trimLines: 3,
                trimMode: TrimMode.Line,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                'Related Movie',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 130, // Define height for the ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedmovie.length > 8 ? 8 : relatedmovie.length,
                itemBuilder: (context, index) {
                  var similarmovie = relatedmovie[index];
                  return Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
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
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                                height: 100,
                                color: Colors.grey[800],
                                child: const Icon(Icons.error, color: Colors.red)),

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
}
