import 'package:flutter/material.dart';
import 'package:letsplay/community/community_sreen.dart';
import 'package:letsplay/tournament/participants_tab_screen.dart';
import 'package:letsplay/tournament/results_tab_screen.dart';
import 'package:letsplay/tournament/roadmap_tab_layout.dart';
import 'package:letsplay/tournament/tournament_details.dart';
import 'package:letsplay/tournament/tournament_details_tab_screen.dart';
import 'package:letsplay/utils/app_size.dart';

import '../bottom_nav.dart';
import '../utils/common_widgets.dart';

class TournamentTabLayoutScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentTabLayoutScreen({
    Key? key,
    required this.tournament,
  }) : super(key: key);

  @override
  _CustomTabScreenState createState() => _CustomTabScreenState();
}

class _CustomTabScreenState extends State<TournamentTabLayoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    print("init state tab_layout_main_screen");
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Trigger rebuild when tab changes
      }
    });
  }

  // This function handles the back button press
  Future<bool> _onWillPop() async {
    // Optionally show a dialog to confirm exit
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit the tournament?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // No
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBottomNavBar()),
                    (route) =>
                false, // This clears the stack and prevents returning to this screen
              )
            }, // Yes
            child: Text('Yes'),
          ),
        ],
      ),
    )) ??
        false; // Return false if the dialog was dismissed
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
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
                SizedBox(height: AppSize.getHeight(6, context)),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: AppSize.getWidth(12, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomBottomNavBar()),
                                (route) =>
                            false, // This removes all previous routes
                          );
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      trophy(context, "assets/images/logo.png"),
                      Expanded(
                        child: ShaderMask(
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
                            widget.tournament.name.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSize.getHeight(18, context),
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      trophy(context, "assets/images/logo.png"),
                    ],
                  ),
                ),
                SizedBox(height: AppSize.getHeight(11, context)),
                // TabBar with full width and background blending with purple gradient
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFD5939),
                            Color(0xFFFD7E29),
                            Color(0xFFFDBF2E),
                          ], // Orange gradient for the selected tab
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            25.0), // Rounded effect for the selected tab
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.zero,
                      tabs: [
                        Tab(
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text('Details'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text('Roadmap'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text('Participants'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text('Results'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBarView for the respective screens
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TournamentDetailsTabScreen(tournament: widget.tournament),
                      RoadmapScreen(tournament: widget.tournament),
                      ParticipantsTabScreen(tournament: widget.tournament),
                      ResultsTabScreen(tournament: widget.tournament),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
