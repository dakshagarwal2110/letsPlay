import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:letsplay/apis/all_apis.dart';
import 'package:letsplay/tournament/tournament_details.dart';
import 'package:letsplay/tournament/tournament_screen_new.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../razorpay_implementation/razorpay_api_implementation.dart';
import '../../utils/app_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentParticipationScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentParticipationScreen({super.key, required this.tournament});

  @override
  State<TournamentParticipationScreen> createState() =>
      _TournamentDetailsTabScreenState();
}

class _TournamentDetailsTabScreenState
    extends State<TournamentParticipationScreen> {
  late final Tournament tournamentCopy;
  bool hasAccountOnPlatform = false;
  bool hasReadRules = false;
  bool hasSeenResultSubmission = false;
  bool followsSocialMedia = false;
  final TextEditingController _gamingIdController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tournamentCopy = widget.tournament;
    print("tournament details id is ${tournamentCopy.id}");
  }

  @override
  void dispose() {
    _gamingIdController.dispose();
    super.dispose();
  }

  Future<void> _participateInTournament() async {
    print('participateTournamnet called');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessTok = prefs.getString('accessToken');
    String? loginData = prefs.getString('login_data');

    if (accessTok == null || loginData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to participate')),
      );
      return;
    }
    print('participateTournamnet loginData ${loginData}');

    Map<String, dynamic> storedLoginData = jsonDecode(loginData);

    String? userId = storedLoginData["user"]["id"];

    // Remaining checks and API call as in your original function
    if (!hasAccountOnPlatform ||
        !hasReadRules ||
        !hasSeenResultSubmission ||
        !followsSocialMedia) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete all requirements to participate')),
      );
      Get.snackbar(
        'Error occurred!',
        "Please complete all requirements to participate",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return;
    }
    print("participateTournamnet Tournament participant ID: $userId");

    if (_gamingIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Gaming ID')),
      );
      return;
    }

    setState(() {
      isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RazorpayScreen(tournament: widget.tournament,),
      ),
    );

    //open this to participate


    // setState(() {
    //   isLoading = true;
    // });

    // String url = '$baseUrl/api/v1/tournament/${tournamentCopy.id}/participate';
    // print("participateTournamnet url is $url");
    // try {
    //   final response = await http.post(
    //     Uri.parse(url),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer $accessTok',
    //     },
    //     body: jsonEncode({
    //       "userId": userId,
    //       "gameId": _gamingIdController.text.trim(),
    //     }),
    //   );
    //
    //   setState(() {
    //     isLoading = false;
    //   });
    //
    //   if (response.statusCode == 200) {
    //     print('participateTournamnet 200');
    //
    //     Get.snackbar(
    //       "Let's Go!",
    //       "Participation successful",
    //       backgroundColor: Colors.green,
    //       colorText: Colors.black,
    //       snackPosition: SnackPosition.BOTTOM,
    //       borderRadius: 8,
    //       margin: EdgeInsets.all(16),
    //       duration: Duration(seconds: 3),
    //       snackStyle: SnackStyle.FLOATING,
    //     );
    //   } else {
    //     print(
    //         'participateTournamnet ${response.statusCode} and response ${response.body}');
    //
    //     Get.snackbar(
    //       'Failed to participate!',
    //       "Error occurred!",
    //       backgroundColor: Colors.red,
    //       colorText: Colors.white,
    //       snackPosition: SnackPosition.BOTTOM,
    //       borderRadius: 8,
    //       margin: EdgeInsets.all(16),
    //       duration: Duration(seconds: 3),
    //       snackStyle: SnackStyle.FLOATING,
    //     );
    //   }
    // } catch (e) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   Get.snackbar(
    //     'Failed to participate!',
    //     "Error occurred!",
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //     borderRadius: 8,
    //     margin: EdgeInsets.all(16),
    //     duration: Duration(seconds: 3),
    //     snackStyle: SnackStyle.FLOATING,
    //   );
    // }
  }

  Widget _buildCheckbox(
      String text, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.orangeAccent,
      checkColor: Colors.white,
      side: BorderSide(color: Colors.orangeAccent),
      value: value,
      onChanged: onChanged,
      title: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(AppSize.getHeight(16, context)),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2B2E52),
              Color(0xFF2B2E52),
              Color(0xFF2B2E52),
              Color(0xFF2B2E52),
            ],
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        widget.tournament.name,
                        style: TextStyle(
                          fontSize: AppSize.getHeight(25, context),
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
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
                _buildCheckbox(
                  "I have made an account on Gaming platform and have a valid Gaming ID on it",
                  hasAccountOnPlatform,
                  (value) =>
                      setState(() => hasAccountOnPlatform = value ?? false),
                ),
                _buildCheckbox(
                  "Yes, I have read all the rules of the game",
                  hasReadRules,
                  (value) => setState(() => hasReadRules = value ?? false),
                ),
                _buildCheckbox(
                  "I have read and seen how to submit result of the tournament",
                  hasSeenResultSubmission,
                  (value) =>
                      setState(() => hasSeenResultSubmission = value ?? false),
                ),
                _buildCheckbox(
                  "I have followed TourneyB Instagram and Discord as results will be declared on Instagram and Discord; for any issue during the tournament, connect with us using Discord",
                  followsSocialMedia,
                  (value) =>
                      setState(() => followsSocialMedia = value ?? false),
                ),
                TextFormField(
                  controller: _gamingIdController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Gaming ID",
                    labelStyle: TextStyle(color: Colors.white70),
                    hintText: "Enter Gaming ID",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Gaming ID'
                      : null,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: isLoading ? null : _participateInTournament,

                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove internal padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFD5939), Color(0xFFFDBF2E)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      alignment: Alignment.center,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Participate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
