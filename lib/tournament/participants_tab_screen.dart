import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsplay/tournament/tournament_details.dart';

class ParticipantsTabScreen extends StatefulWidget {
  final Tournament tournament;
  const ParticipantsTabScreen({super.key, required this.tournament});

  @override
  State<ParticipantsTabScreen> createState() => _ParticipantsTabScreenState();
}

class _ParticipantsTabScreenState extends State<ParticipantsTabScreen> {
  List<Participant> participants = []; // List to hold participant data
  bool isLoading = true; // Control loading state


  @override
  void initState() {
    super.initState();
    print("init state participants_tab");
    fetchParticipants(); // Fetch participants from API
  }

  Future<void> fetchParticipants() async {
    setState(() {
      isLoading = true; // Start the loading indicator
    });

    try {
      // Simulating API delay
      await Future.delayed(const Duration(seconds: 2));

      // Extracting participants from the global tournament object
      if (widget.tournament.playersParticipating.isNotEmpty) {
        setState(() {
          participants = widget.tournament.playersParticipating.map((player) {
            return Participant(
              id: int.tryParse(player.id) ?? 0, // Converting string ID to integer
              name: player.username,
              imageUrl: player.image.isNotEmpty ? player.image : 'assets/images/dp1.png', // Default image if empty
            );
          }).toList();
          isLoading = false; // Stop the loading indicator
        });
      } else {
        // Handle case where no participants are present
        setState(() {
          participants = [];
          isLoading = false;
        });
      }
    } catch (error) {
      // Handle any errors gracefully
      setState(() {
        participants = [];
        isLoading = false;
      });
      print("Error fetching participants: $error");
    }
  }


  @override
  void dispose() {
    super.dispose();
    print("dispose tournament participants tab called");
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
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF7043),)) // Show loading indicator while data is fetched
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomParticipantCard(
              name: participants[index].name,
              username: "Alpha",
              imageUrl: participants[index].imageUrl,
            ), // Custom participant card
          );
        },
      ),
    );
  }
}

// Model class for Participant
class Participant {
  final int id;
  final String name;
  final String imageUrl;

  Participant({required this.id, required this.name, required this.imageUrl});
}



class CustomParticipantCard extends StatelessWidget {
  final String name;
  final String username;
  final String imageUrl;

  const CustomParticipantCard({
    required this.name,
    required this.username,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: const EdgeInsets.all(1.0), // Padding for the border
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32.0), // Make sure it's larger than the inner container
        ),
        child: Container(
          padding: const EdgeInsets.all(9.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF563772),
                Color(0xFF63447C),
                Color(0xFF5D4E73),



              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFFF7043), // Orange border for selected
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 65,
                    height: 65,

                  ),
                ),


              ),
              const SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                    ),
                  ),
                  Text(
                    '($username)',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  }
}
