import 'package:flutter/material.dart';
import 'package:letsplay/tournament/tournament_details.dart';
import 'package:letsplay/tournament/tournament_participation/tournament_participation_screen.dart';
import 'package:letsplay/tournament/tournament_screen_new.dart';
import 'package:letsplay/utils/app_size.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/youtube_player_widget.dart';

class TournamentDetailsTabScreen extends StatefulWidget {

  final Tournament tournament;
  const TournamentDetailsTabScreen({super.key, required this.tournament});

  @override
  State<TournamentDetailsTabScreen> createState() =>
      _TournamentDetailsTabScreenState();
}

class _TournamentDetailsTabScreenState
    extends State<TournamentDetailsTabScreen> {
  
  late final Tournament tournament_copy;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tournament_copy = widget.tournament;
    print("init state tournament_details_tab");
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose tournament details tab called");
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TournamentScreenNew(),
      ),
    );
    return false; // Prevents default back button behavior
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(
            top: AppSize.getHeight(16, context),
            right: AppSize.getWidth(16, context),
            left: AppSize.getWidth(16, context),
          ),
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
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full-width image with subtle shadow and rounded corners
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.tournament.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                   SizedBox(height: AppSize.getHeight(20, context)),

                  // Prize Money Section
                   Text(
                    'Prize Money: ₹${widget.tournament.prizePool}',

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: AppSize.getHeight(21, context)
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(20, context)),

                  Text(
                    'Entry Fee: ₹${widget.tournament.entryToken}',

                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: AppSize.getHeight(21, context)
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(20, context)),

                  // Prize Money Section
                  Text(
                    'Participants: ${widget.tournament.participants}',

                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: AppSize.getHeight(21, context)
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(30, context)),
                  // "Join" Button with a smoother, more engaging design
                  GestureDetector(
                    onTap: () {
                      // Define your participation logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TournamentParticipationScreen(tournament: widget.tournament,),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.getHeight(12, context),
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFDBF2E),
                            Color(0xFFFD5939),
                            Color(0xFFFD7E29),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "JOIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSize.getHeight(19, context),
                          fontFamily: 'Mercenary',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rules section with better styling
                   Text(
                    'Tournament Rules:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.getHeight(22, context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Example of rules text with spacing (Add your own rules here)

                  Text(
                    widget.tournament.rules.join('\n'),
                    style: TextStyle(
                        color: Colors.white70, fontSize: AppSize.getHeight(19, context), letterSpacing: 2),
                  ),

                  SizedBox(height: AppSize.getHeight(21, context)),

                  // Rules section with better styling
                   Text(
                    'Score Submission Rules:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.getHeight(22, context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    height: AppSize.getHeight(270, context),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset("assets/images/submit_score_banner.png" ,fit: BoxFit.contain,)
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Example of rules text with spacing (Add your own rules here)
                  Text(
                    widget.tournament.scoreSubmissionRules.join('\n'),
                    style: TextStyle(
                        color: Colors.white70, fontSize: AppSize.getHeight(19, context), letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ],
          )),
    );
  }
}
