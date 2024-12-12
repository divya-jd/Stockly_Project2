import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsFeedScreen extends StatefulWidget {
  final List<String> myStockSymbols;

  const NewsFeedScreen({Key? key, required this.myStockSymbols}) : super(key: key);

  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  bool isLoading = true;
  List<dynamic> newsArticles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = 'ct7md91r01qkgg0urj1gct7md91r01qkgg0urj20';
    const url = 'https://finnhub.io/api/v1/news?category=general&token=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          newsArticles = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch news');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching news: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Financial News',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkTheme ? const Color(0xFF1E1E2C) : const Color(0xFF4CAF50),
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30),
            onPressed: fetchNews,
          ),
        ],
      ),
      body: Container(
        color: isDarkTheme ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.tealAccent),
        )
            : newsArticles.isEmpty
            ? Center(
          child: Text(
            'No news available',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black87,
              fontSize: 18,
            ),
          ),
        )
            : RefreshIndicator(
          onRefresh: fetchNews,
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: newsArticles.length,
            itemBuilder: (context, index) {
              final article = newsArticles[index];
              return buildNewsCard(article, isDarkTheme);
            },
          ),
        ),
      ),
    );
  }

  Widget buildNewsCard(Map<String, dynamic> article, bool isDarkTheme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkTheme ? const Color(0xFF1E1E2C) : const Color(0xFFFFFFFF),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        title: Text(
          article['headline'] ?? 'No Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              article['summary'] ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDarkTheme ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            article['image'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                article['image'],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Center(
                    child: CircularProgressIndicator(
                      color: Colors.tealAccent,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
        trailing: Icon(
          Icons.open_in_new,
          color: isDarkTheme ? Colors.tealAccent : Colors.blueAccent,
        ),
        onTap: () {
          if (article['url'] != null) {
            _launchURL(article['url']);
          }
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
