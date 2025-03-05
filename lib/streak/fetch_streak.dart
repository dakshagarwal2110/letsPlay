import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class StreakShowCalender extends StatefulWidget {
  const StreakShowCalender({Key? key}) : super(key: key);

  @override
  State<StreakShowCalender> createState() => _StreakShowCalenderState();
}

class _StreakShowCalenderState extends State<StreakShowCalender> {
  int streakCount = 0;
  List<DateTime> streakDates = [];
  final String apiUrl = 'https://tourneyb-backend.vercel.app/api/v1/feature/streak';

  @override
  void initState() {
    super.initState();
    _fetchStreakData();
  }

  Future<void> _fetchStreakData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token != null) {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("streakdays are: $data");
        setState(() {
          streakCount = data['streak']['streakCount'];
          streakDates = (data['streak']['streakDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList();
        });
      } else {
        print('Failed to fetch streak data: ${response.statusCode}');
      }
    }
  }

  bool _isStreakDate(DateTime day) {
    return streakDates.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2E52),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B2E52),
              Color(0xFF6173C7),
              Color(0xFF2B2E52),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            // AppBar with Back Arrow and Title
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Streak',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Streak Count with Fire Animation
            Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Lottie.asset('assets/animations/streak.json'),
                ),
                Text(
                  '$streakCount Days',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Calendar with Fire Icon on Streak Dates
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2033, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      return _isStreakDate(day)
                          ? Center(
                        child: Image.asset(
                          'assets/images/fire.png',
                          width: 20,
                          height: 20,
                        ),
                      )
                          : null;
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
