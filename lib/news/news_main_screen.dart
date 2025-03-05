import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../apis/all_apis.dart';
import '../auth/login.dart';
import '../utils/app_size.dart';
import '../utils/app_strings.dart';
import '../utils/common_widgets.dart';

class NewsMainScreen extends StatefulWidget {
  const NewsMainScreen({super.key});

  @override
  State<NewsMainScreen> createState() => _NewsMainScreenState();
}

class _NewsMainScreenState extends State<NewsMainScreen> {
  // State variables
  List<Map<String, dynamic>> newsList = []; // List to hold news items
  int currentPage = 1; // Current page number
  final int perPage = 2; // Number of items per page
  bool isLoading = false; // Indicates if data is being loaded
  bool hasMore = true; // Indicates if more data is available
  bool isError = false; // Indicates if an error occurred

  @override
  void initState() {
    super.initState();
    print("init state tournament_screen_new");
    fetchNews(); // Fetch the first page of news
  }

  // Method to fetch news from the API
  Future<void> fetchNews() async {
    if (isLoading || !hasMore) return; // Prevent duplicate requests

    setState(() {
      isLoading = true;
      isError = false;
    });

    final String apiUrl =
        "$baseUrl/api/v1/news?&page=$currentPage&per_page=$perPage&sortBy=createdAt&sortOrder=desc";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          List<dynamic> fetchedData = responseData['data'];
          final Map<String, dynamic> meta = responseData['meta'];

          setState(() {
            currentPage += 1;
            newsList.addAll(fetchedData.cast<Map<String, dynamic>>());

            // Determine if more data is available
            if (newsList.length >= meta['total']) {
              hasMore = false;
            }
          });
        } else {
          // Handle API returning success: false
          setState(() {
            isError = true;
          });
        }
      } else {
        // Handle non-200 responses
        setState(() {
          isError = true;
        });
      }
    } catch (e) {
      // Handle exceptions
      print("Error fetching news: $e");
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Refresh the news list (optional, e.g., pull-to-refresh)
  Future<void> refreshNews() async {
    setState(() {
      newsList.clear();
      currentPage = 1;
      hasMore = true;
      isError = false;
    });
    await fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF2B2E52), // Set your preferred color here
      statusBarIconBrightness: Brightness.light, // Controls the icon color
    ));

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(

            gradient: LinearGradient(
              begin: Alignment(-0.8, -0.5),
              end: Alignment(0.8, 0.5),
              colors: [
                Color(0xFF2B2E52), // Top side color
                Color(0xFF2B2E52),
                Color(0xFF2B2E52), // Top side color
                Color(0xFF2B2E52),
                Color(0xFF2B2E52), // Top side color
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),

          ),
          child: Column(
            children: [
              // Fixed header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.getWidth(12, context),
                  vertical: AppSize.getHeight(8, context),
                ),
                decoration: BoxDecoration(
                  color: Color(0x4D606485), // Transparent dark color

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10, // Increased blur radius for a stronger blur effect
                      spreadRadius: 2, // Optional: Adjust the spread for a wider shadow
                    ),
                  ],
                ),
// Background color for the header
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        trophy(context, "assets/images/logo.png"),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFD5939),
                              Color(0xFFFD7E29),
                              Color(0xFFFDBF2E),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(
                              Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                          child:  Text(
                            AppStrings.appName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontFamily: 'Mercenary',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trophy(context, "assets/images/logo.png"),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: socialMediaIconDiscord(
                              context, "assets/images/discord.png"),
                        ),
                        SizedBox(width: AppSize.getWidth(15, context)),
                        socialMediaIcon(context, "assets/images/instagram.png"),
                        SizedBox(width: AppSize.getWidth(15, context)),
                        socialMediaIcon(context, "assets/images/twitter.png"),
                      ],
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.getWidth(12, context)),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2B2E52), // Top side color
                    Color(0xFF2B2E52),
                      ],
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: refreshNews, // Pull-to-refresh functionality
                    color: Color(0xFFFD5939),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(), // Ensures pull to refresh works even if the list isn't scrollable
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section title
                          SizedBox(height: AppSize.getHeight(5, context)),
                          Row(
                            children: [
                              Text(
                                "Gaming updates",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSize.getHeight(25, context),
                                  fontFamily: 'Mercenary',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.getHeight(2, context)),

                          //buildOrangeGradientCards(context),

                          // News cards
                          Column(
                            children: newsList
                                .map((news) => newsCard(context, news))
                                .toList(),
                          ),

                          // Load More button or loading indicator
                          if (isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSize.getHeight(16, context)),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else if (hasMore)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSize.getHeight(16, context)),
                              child: Container(

                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFFD5939),
                                        Color(0xFFFDBF2E)], // Gradient colors
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8), // Matching the button's border radius
                                  ),
                                  child: ElevatedButton(
                                    onPressed: fetchNews,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent, // Set background to transparent
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppSize.getWidth(24, context),
                                          vertical: AppSize.getHeight(12, context)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0, // Remove shadow if needed
                                    ),
                                    child: Center(
                                      child: const Text(
                                        "Load More",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Mercenary',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )

                              ),
                            )
                          else
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSize.getHeight(16, context)),
                              child: const Center(
                                child: Text(
                                  "No more news available.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Mercenary',
                                  ),
                                ),
                              ),
                            ),

                          // Display error message if any
                          if (isError)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSize.getHeight(16, context)),
                              child: Center(
                                child: Text(
                                  "Failed to load news. Please try again.",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                    fontFamily: 'Mercenary',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget newsCard(BuildContext context, Map<String, dynamic> news) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: AppSize.getHeight(12, context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFFD7E29),
          width: 1.5,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.getHeight(12, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News title
            Text(
              news['title'] ?? 'No Title',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(20, context),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSize.getHeight(10, context)),

            // News image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                news['imageUrl'] ??
                    'https://via.placeholder.com/150', // Fallback image
                width: double.infinity,
                height: AppSize.getHeight(150, context),
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: AppSize.getHeight(150, context),
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: AppSize.getHeight(150, context),
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSize.getHeight(10, context)),

            // News description
            Text(
              news['description'] ?? 'No Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(17, context),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: AppSize.getHeight(8, context)),
          ],
        ),
      ),
    );
  }

  // Widget for Discord icon (used in header)
  Widget socialMediaIcon(BuildContext context, String assetPath) {
    return Container(
      height: AppSize.getHeight(20, context),
      width: AppSize.getWidth(20, context),
      child:  ShaderMask(
        shaderCallback: (Rect bounds) {
          return  LinearGradient(
            colors: [
              Color(0xFFFD5939),
              Color(0xFFFD7E29),
              Color(0xFFFDBF2E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget socialMediaIconDiscord(BuildContext context, String assetPath) {
    return Container(
      height: AppSize.getHeight(28, context),
      width: AppSize.getWidth(28, context),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return  LinearGradient(
            colors: [
              Color(0xFFFD5939),
              Color(0xFFFD7E29),
              Color(0xFFFDBF2E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  Widget trophy(BuildContext context, String assetPath) {
    return Container(
      height: AppSize.getHeight(28, context),
      width: AppSize.getWidth(28, context),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
