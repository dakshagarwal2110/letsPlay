import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> leaderboardData = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData({bool isLoadMore = false}) async {
    if (isLoadMore && (isLoadingMore || !hasMoreData)) return;

    setState(() {
      if (isLoadMore) {
        isLoadingMore = true;
      } else {
        isLoading = true;
      }
    });

    final requestBody = jsonEncode({
      "sortBy": "winnings",
      "page": currentPage,
      "per_page": 20,
    });

    try {
      final response = await http.post(
        Uri.parse('https://tourneyb-backend.vercel.app/api/v1/tournament/leaderboard'),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          if (isLoadMore) {
            leaderboardData.addAll(data['data']);
          } else {
            leaderboardData = data['data'];
          }

          hasMoreData = currentPage < data['total_pages'];
          if (hasMoreData) currentPage++;
        });
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  Future<void> refreshLeaderboardData() async {
    setState(() {
      leaderboardData.clear();
      currentPage = 1;
      hasMoreData = true;
    });
    await fetchLeaderboardData();
  }

  Widget buildTopThree() {
    if (leaderboardData.length < 3) return SizedBox();

    final topThree = leaderboardData.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(topThree.length, (index) {
          final user = topThree[index];
          final bool isFirst = index == 0;

          return Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: isFirst ? 50 : 40,
                    backgroundImage: CachedNetworkImageProvider(user['image']),
                  ),
                  if (isFirst)
                    Positioned(
                      top: -10,
                      child: Image.asset(
                        "assets/images/crown.png",
                        height: 28,
                        width: 28,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                user['username'] ?? 'Unknown',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${user['winnings']}',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildLeaderboardList() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16),
              itemCount: leaderboardData.length - 3,
              itemBuilder: (context, index) {
                final user = leaderboardData[index + 3];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['image'] != null
                        ? CachedNetworkImageProvider(user['image'])
                        : AssetImage('assets/images/dp1.png'), // Use a default image for null
                  ),
                  title: Text(
                    user['username'] ?? 'Unknown', // Fallback to 'Unknown' if username is null
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Winnings: ₹${user['winnings'] ?? 0}', // Fallback to 0 if winnings is null
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    '#${index + 4}',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                );

              },
            ),
          ),
          if (hasMoreData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => fetchLeaderboardData(isLoadMore: true),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.orange,
                ),
                child: isLoadingMore
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text('Load More'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2B2E52), Color(0xFF38567E), Color(0xFF2B2E52)],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(
                  'Leaderboard',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              if (leaderboardData.isNotEmpty) buildTopThree(),
              isLoading
                  ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : buildLeaderboardList(),
            ],
          ),
        ),
      ),
    );
  }


}
