import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayMovieScreen extends StatefulWidget {
  final int movieId;
  const PlayMovieScreen({super.key, required this.movieId});

  @override
  State<PlayMovieScreen> createState() => _PlayMovieScreenState();
}

class _PlayMovieScreenState extends State<PlayMovieScreen> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView controller
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          print("Page started loading: $url");
        },
        onPageFinished: (url) {
          print("Page finished loading: $url");
        },
        onWebResourceError: (error) {
          print("Error loading movie: ${error.description}");
        },
      ))
      ..loadRequest(Uri.parse('https://www.2embed.stream/embed/movie/${widget.movieId}'));
  }

  @override



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Movie'),
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
