import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:letsplay/auth/login.dart';
import 'package:letsplay/leaderboard/leaderboard_screen.dart';
import 'package:letsplay/tournament/tournament_details.dart';
import 'package:letsplay/tournament/tournament_tab_layout_screen.dart';
import 'package:letsplay/utils/app_strings.dart';
import 'package:letsplay/utils/app_styles.dart';
import 'package:letsplay/utils/loader.dart';

import '../utils/app_size.dart';
import '../utils/common_functions.dart';
import '../utils/common_widgets.dart';
import '../win_tokens/random_games/chess/snake_and_ladder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TournamentScreenNew extends StatefulWidget {
  const TournamentScreenNew({super.key});

  @override
  State<TournamentScreenNew> createState() => _TournamentScreenNewState();
}

class _TournamentScreenNewState extends State<TournamentScreenNew> {
  late List<Winners> _winners = [];

  ScrollController _scrollControllerTournament = ScrollController();
  ScrollController _scrollControllerWinner = ScrollController();
  ScrollController _scrollControllerPastTournament = ScrollController();
  bool isLoading = true;
  List<Tournament> tournaments = [];

  void _scrollForwardTournament() {
    _scrollControllerTournament.animateTo(
      _scrollControllerTournament.offset + 200,
      // Adjust the scroll amount as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollForwardWinner() {
    _scrollControllerWinner.animateTo(
      _scrollControllerWinner.offset + 200,
      // Adjust the scroll amount as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollForwardPastTournament() {
    _scrollControllerPastTournament.animateTo(
      _scrollControllerPastTournament.offset + 200,
      // Adjust the scroll amount as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2B2E52), // Set your preferred color here
      statusBarIconBrightness: Brightness.light, // Controls the icon color
    ));

    return SafeArea(
        child: Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Loader.showLoading("Loading your battleground!");
          setState(() {
            _winners.clear();
            tournaments.clear();
          });
          await callApis();
          Loader.hideLoading();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2B2E52), // Top side color
                Color(0xFF2B2E52), // Bottom side color
              ],
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
                ), // Transparent dark color

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                      // Increased blur radius for a stronger blur effect
                      spreadRadius:
                          2, // Optional: Adjust the spread for a wider shadow
                    ),
                  ],
                ), // Background color for the header
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        trophy(context, "assets/images/logo.png"),
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
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: GestureDetector(
                              onTap: () {
                                launchDiscord(context, "HbRaMBa7");
                              },
                              child: socialMediaIconDiscord(
                                  context, "assets/images/discord.png"),
                            )),
                        SizedBox(width: AppSize.getWidth(15, context)),
                        GestureDetector(
                          onTap: () {
                            openInstagramChannel2();
                          },
                          child: socialMediaIcon(
                              context, "assets/images/instagram.png"),
                        ),
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
                    left: AppSize.getWidth(12, context),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.8, -0.5),
                      end: Alignment(0.8, 0.5),
                      colors: [
                        Color(0xFF2B2E52), // Top side color
                        Color(0xFF2B2E52),
                        Color(0xFF3F4179), // Top side color
                        Color(0xFF373B60),
                        Color(0xFF2B2E52), // Top side color
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                  // Background color for the content area
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    // Vertical scrolling enabled
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Tournaments Section

                        Row(
                          children: [
                            Text(
                              "Featured Tournaments",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSize.getHeight(25, context),
                                fontFamily: 'Mercenary',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(8, context)),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollControllerTournament,
                                child: Row(
                                  children: tournaments.map((tournament) {
                                    return _buildTournamentCard(
                                        context, tournament);
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                                onPressed: _scrollForwardTournament,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(8, context)),

                        Row(
                          children: [
                            Text(
                              "Leaderboard",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSize.getHeight(25, context),
                                fontFamily: 'Mercenary',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        SizedBox(height: AppSize.getHeight(8, context)),
                        buildLeaderBoardCards(context, "Legends Arena",
                            "Are you ready to become a legend?"),
                        SizedBox(height: AppSize.getHeight(8, context)),

                        // Winners Section
                        Row(
                          children: [
                            Text(
                              "Winners",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSize.getHeight(25, context),
                                fontFamily: 'Mercenary',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        SizedBox(height: AppSize.getHeight(8, context)),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollControllerWinner,
                                child: Row(
                                  children: _winners.map((winner) {
                                    return _buildWinnerCard(context, winner);
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                                onPressed: _scrollForwardWinner,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(8, context)),

                        // Past Tournaments Section

                        Row(
                          children: [
                            Text(
                              "Win Tokens",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSize.getHeight(25, context),
                                fontFamily: 'Mercenary',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiceGameScreen(
                                      ),
                                    ),

                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        SizedBox(height: AppSize.getHeight(8, context)),
                        buildWinToken(context, "Unlock Rewards",
                            "Complete daily quests and earn tokens!"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> fetchTournaments() async {
    Loader.showLoading("Getting your profile");
    final url =
        'https://tourneyb-backend.vercel.app/api/v1/tournament/list?page=1&per_page=5&sortBy=date&sortOrder=desc';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        tournaments = List<Tournament>.from(
            data['data'].map((t) => Tournament.fromJson(t)));
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
    Loader.hideLoading();
  }

  @override
  void initState() {
    super.initState();
    // Fetch the first page of winners
    callApis();
  }

  Future<void> callApis() async {
    await fetchTournaments();
    await fetchWinners(1);
    await callStreakApi();
  }


  Future<void> callStreakApi() async {
    // Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print("Access token not found in SharedPreferences.");
      return;
    }

    // Set up the headers with the Bearer token
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // Define the API endpoint
    const url = 'https://tourneyb-backend.vercel.app/api/v1/feature/streak';

    // Define the body of the POST request if necessary
    final body = jsonEncode({
      // Add key-value pairs here if the API expects specific data
    });

    try {
      // Make the POST request
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      // Print the response
      if (response.statusCode == 200) {
        print("Response streak : ${jsonDecode(response.body)}");
      } else {
        print("Response streak Failed to call API. Status Code: ${response.statusCode}");
        print("Response streak Response Body: ${response.body}");
      }
    } catch (e) {
      print("Response streak An error occurred: $e");
    }
  }
  Future<void> fetchWinners(int page) async {
    Loader.showLoading("Getting your profile");
    try {
      // API call with POST request
      final response = await http.post(
        Uri.parse(
            'https://tourneyb-backend.vercel.app/api/v1/tournament/winners'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'page': page, 'per_page': 8}),
      );

      print("fetch_winners_api_status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Decode the response
        final responseData = jsonDecode(response.body);
        final List<dynamic> tournaments = responseData['data'];

        List<Winners> fetchedWinners = [];

        // Iterate through tournaments and extract winners
        for (var tournament in tournaments) {
          List<dynamic> winnersList = tournament['winners'];
          for (var winner in winnersList) {
            fetchedWinners.add(Winners(
              username: winner['username'],
              tournament_name: tournament['name'],
              // Tournament name
              image: winner['image'],
              date: tournament['date'],
              // Tournament date
              amount: winner['winnings'], // Winnings as amount
            ));
          }
        }

        // Update state with fetched winners
        setState(() {
          _winners = fetchedWinners;
        });
        Loader.hideLoading();

      } else {
        // Log error for non-200 responses
        Loader.hideLoading();

        print(
            "fetch_winners_api_failed: ${response.statusCode} ${response.body}");
      }
    } catch (error) {
      // Catch any errors that occur during the API call or parsing
      Loader.hideLoading();
      print("fetch_winners_api_error: $error");

      // You could set some error message in the state or show a snackbar, e.g.
    }
  }

  @override
  void dispose() {
    _scrollControllerTournament.dispose();
    _scrollControllerWinner.dispose();
    _scrollControllerPastTournament.dispose();
    super.dispose();
    print("tournament_screen_new dispose state tournament_screen_new");
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    // Calculate the filled slots percentage
    double filledSlotsPercentage =
        tournament.playersParticipating.length / tournament.participants;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TournamentTabLayoutScreen(
              tournament: tournament,
            ),
          ),

        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          width: 300,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  tournament.image ?? 'https://via.placeholder.com/150',
                  // Fallback image
                  width: double.infinity,
                  height: AppSize.getHeight(120, context),
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
              SizedBox(height: 5),
              // Tournament name
              Text(
                tournament.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Divider(color: Colors.orangeAccent, thickness: 1),
              // Row with 4 columns
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Prize Pool',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₹${tournament.prizePool}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Winners',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${tournament.winners.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Entry Fee',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₹${tournament.entryToken}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Rounds',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${tournament.rounds}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.orangeAccent, thickness: 1),
              // Progress bar and filled slots text
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Slots Filled: ${tournament.playersParticipating.length}/${tournament.participants}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: filledSlotsPercentage,
                      backgroundColor: Colors.grey[700],
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              // "Let's Go" Button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Define your action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TournamentTabLayoutScreen(
                            tournament: tournament,
                          ),
                        ),

                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      'Let\'s Go',
                      style:
                          Styles.headLineStyle4.copyWith(color: Colors.white),
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

  Widget _buildWinnerCard(BuildContext context, Winners winner) {
    return GestureDetector(
      onTap: () {
        print("On tap card Winner: ${winner.username}");
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          width: 180,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFFFD7E29),
              width: 1.5,
            ),
            gradient: LinearGradient(
              colors: [
                Colors.orangeAccent.withOpacity(0.3),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF36013B),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(winner.image),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Tournament name
              Text(
                winner.username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),

              // Example amount (you can modify this as per your requirements)
              Text(
                '${winner.tournament_name}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),
              // Date
              Text(
                '${formatDateToIST(winner.date)}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 8),
              // Example amount (you can modify this as per your requirements)
              Text(
                'Winning +₹${winner.amount.toString()}',
                style: TextStyle(
                  color: Color(0xFF008C07),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget coinWalletMediaIcon(BuildContext context, String assetPath) {
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
      height: AppSize.getHeight(20, context),
      width: AppSize.getWidth(20, context),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
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
          return LinearGradient(
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
