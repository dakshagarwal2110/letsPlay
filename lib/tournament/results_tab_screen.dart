import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsplay/tournament/tournament_details.dart';

class ResultsTabScreen extends StatefulWidget {
  final Tournament tournament;
  const ResultsTabScreen({super.key, required this.tournament});

  @override
  State<ResultsTabScreen> createState() => _ResultsTabScreenState();
}

class _ResultsTabScreenState extends State<ResultsTabScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state results_tab");
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose tournament results tab called");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Center(
        child: Text(
          'Results screen',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

  }
}
