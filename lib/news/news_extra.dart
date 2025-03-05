import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_size.dart';

class NewsMainScreen extends StatefulWidget {
  const NewsMainScreen({super.key});

  @override
  State<NewsMainScreen> createState() => _NewsMainScreenState();
}

class _NewsMainScreenState extends State<NewsMainScreen> {
  final List<Map<String, dynamic>> newsList = [
    {
      "id": 1,
      "title": "Exciting Tournament Update!",
      "description": "A big update on the upcoming tournament.",
      "image": "assets/images/uno.jpg",
      "reactions": {
        "Wow": 2,
        "Super excited": 10,
        "Excited": 5,
      },
      "selectedReaction": null, // To track which reaction is selected
    },
    // Add more news items as needed
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6A0572), // Set your preferred color here
      statusBarIconBrightness: Brightness.light, // Controls the icon color
    ));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Fixed header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.getWidth(12, context),
                vertical: AppSize.getHeight(8, context),
              ),
              color: Color(0xFF6A0572), // Background color for the header
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      socialMediaIconDiscord(
                          context, "assets/images/logo.png"),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFFFD5939),
                            Color(0xFFFD7E29),
                            Color(0xFFFDBF2E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(Rect.fromLTWH(
                            0.0, 0.0, bounds.width, bounds.height)),
                        child: Text(
                          "TourneyB",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontFamily: 'Mercenary',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      socialMediaIconDiscord(
                          context, "assets/images/logo.png"),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Add navigation or any other action here
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
                padding: EdgeInsets.only(
                  left: AppSize.getWidth(0, context),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6A0572),
                      Color(0xFF9A34A6),
                      Color(0xFF6A0572),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          Text(
                            "Gaming updates",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSize.getHeight(25, context),
                              fontFamily: 'Mercenary',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(8, context)),

                      // News cards
                      Column(
                        children: newsList
                            .map((news) => newsCard(context, news))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newsCard(BuildContext context, Map<String, dynamic> news) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          vertical: AppSize.getHeight(12, context),
          horizontal: AppSize.getWidth(12, context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE069A2),
            Color(0xFFB74D79),
            Color(0xFF814459),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.getHeight(12, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News title
            Text(
              news['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(20, context),
                fontWeight: FontWeight.bold,
                fontFamily: 'Mercenary',
              ),
            ),
            SizedBox(height: AppSize.getHeight(8, context)),

            // Circular bordered news image
            Image.asset(
              news['image'],
              width: double.infinity,
              height: AppSize.getHeight(150, context),
              fit: BoxFit.cover,
            ),
            SizedBox(height: AppSize.getHeight(8, context)),

            // News description
            Text(
              news['description'],
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(16, context),
                fontFamily: 'Mercenary',
              ),
            ),
            SizedBox(height: AppSize.getHeight(8, context)),

            // Reactions list with counters

            Wrap(
              spacing: AppSize.getWidth(8, context),
              children: news['reactions'].keys.map<Widget>((reaction) {
                bool isSelected = news['selectedReaction'] == reaction;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        // Deselect reaction and decrease count
                        news['selectedReaction'] = null;
                        news['reactions'][reaction]--;
                      } else {
                        // Select reaction and increase count
                        news['selectedReaction'] = reaction;
                        news['reactions'][reaction]++;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppSize.getWidth(5, context)),


                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(AppSize.getWidth(8, context))),
                      color: isSelected
                          ? Colors.orange
                          : Colors.white, // Selected state
                      shape: BoxShape.rectangle,
                      gradient: isSelected
                          ? LinearGradient(
                        colors: [Color(0xFFFF7F50), Color(0xFFFF4500)],
                      )
                          : null,
                      border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Color(0xFFFD7E29)),
                    ),
                    child: Text(
                      '${news['reactions'][reaction]} $reaction',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: AppSize.getHeight(14, context),
                        fontFamily: 'Mercenary',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("init state tournament_screen_new");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget socialMediaIconDiscord(BuildContext context, String assetPath) {
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

  Widget socialMediaIcon(BuildContext context, String assetPath) {
    return Container(
      height: AppSize.getHeight(26, context),
      width: AppSize.getWidth(26, context),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
