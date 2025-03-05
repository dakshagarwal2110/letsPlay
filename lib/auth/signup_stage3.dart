import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:letsplay/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:letsplay/utils/loader.dart';


import '../apis/all_apis.dart';
import '../utils/common_functions.dart';

class SignupStage3 extends StatefulWidget {

  final Map<String, String> userData;
  const SignupStage3({super.key, required this.userData});

  @override
  State<SignupStage3> createState() => _SignupStage3State();
}

class _SignupStage3State extends State<SignupStage3> {
  final _formKey = GlobalKey<FormState>();

  // List of image URLs or assets (for demonstration, replace with your actual images)
  // final List<String> imageUrls = [
  //   'assets/images/dp1.png', // Replace with actual images
  //   'assets/images/dp2.png',
  //   'assets/images/dp3.png',
  //   'assets/images/dp4.png',
  //   'assets/images/dp5.png',
  //   'assets/images/dp6.png',
  //   'assets/images/dp7.png', // Replace with actual images
  //   'assets/images/dp8.png',
  //   'assets/images/dp9.png',
  //   'assets/images/dp10.png',
  //   'assets/images/dp11.png',
  //   'assets/images/dp12.png',
  // ];

  final List<String> imageUrlsAll = [
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/360_F_320706748_9EHt2oP8NgekFXsM3INJtN7HhdRHOTJN-removebg-preview.png?alt=media&token=0d91c6aa-d6cc-499d-87c5-fe62d04cf87e',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/360_F_468316190_CjhrB55W6Nkosin4F1Cn3GOLGVdc5Un1-removebg-preview.png?alt=media&token=ecdf225a-6776-484c-b6c7-b124aaa78e2b',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/360_F_732407393_gBqqSjy2oFLacA79sRwx75BG3bXwyZ88-removebg-preview.png?alt=media&token=b9b1c5dc-efe2-4ec7-88b4-0e3215905257',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/Screenshot_2024-09-12_200349-removebg-preview.png?alt=media&token=bfa5c608-ab6b-4b3c-bde3-b508455aa1d6',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/Screenshot_2024-09-12_200749-removebg-preview.png?alt=media&token=64d257e8-1514-4178-b6f4-43e8f3ebe525',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/Screenshot_2024-09-12_200924-removebg-preview.png?alt=media&token=fa6d9a36-0404-44b9-b8d1-4af0718aecfd',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/Screenshot_2024-09-12_200955-removebg-preview.png?alt=media&token=b9199ebe-d007-495a-a22d-b0092a845bfb',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/Screenshot_2024-09-12_201112-removebg-preview.png?alt=media&token=82f425f2-8012-4350-a0bd-fbcbffcd01d0',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/b0ce89c349573bae1264017ce5deb3b7-removebg-preview.png?alt=media&token=df13c850-d743-4853-ab00-3010f1c6a15a',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/ea5c79e256b91e6512a87f39828f8808-removebg-preview.png?alt=media&token=1cded732-d782-4292-ab11-0379dd1efadf',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/hyper-gaming-logo-by-manik-hossain-dribbble-removebg-preview.png?alt=media&token=5837f7fe-aacb-4bdc-9501-c68911af7259',
    'https://firebasestorage.googleapis.com/v0/b/tourneyyb-de9b8.appspot.com/o/ninja-with-two-swords-on-dark-background-gaming-game-e-sport-sports-team-logo-design-vector-removebg-preview.png?alt=media&token=eff6bec4-2b1b-4791-81ba-4a4bb9346293',

  ];



  String? selectedImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000000), // Start color
                  Color(0xFF6A0572), // End color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Blurring effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0), // Add transparency
              ),
            ),
          ),

          // Form Fields
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                      child: const Text(
                        "TourneyB",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 0),

                  const Center(
                    child: Text(
                      "Select Your Avatar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Grid layout for displaying circular images
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 100, // Adjust number of images per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: imageUrlsAll.length,
                    itemBuilder: (context, index) {
                      String imageUrl = imageUrlsAll[index];
                      bool isSelected = selectedImage == imageUrl;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = imageUrl;
                          });
                        },
                        child: FutureBuilder<Image>(
                          future: _loadImageWithRetry(imageUrl, 3), // Retry up to 3 times
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Show loading spinner while loading
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              // If an error occurs after retries, show an error icon
                              return const Center(child: Icon(Icons.error));
                            } else {
                              // Show image if it loads successfully
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 3,
                                        color: isSelected ? const Color(0xFFFD5939) : Colors.transparent, // Orange border for selected
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: snapshot.data!,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Continue Button
                  Container(
                    width: double.infinity, // Adjust the width as per your layout
                    height: 50, // Adjust the height as needed
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        hideSoftKeyboard(context);
                        // Your onPressed function
                        print("Selected Image: $selectedImage");
                        if (validateImage()) {

                          widget.userData["image"] = selectedImage!;
                          registerUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontFamily: 'Mulish', // Font size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Function to retry image loading
  Future<Image> _loadImageWithRetry(String url, int retries) async {
    try {
      final networkImage = Image.network(
        url,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
      // Await for the image to be loaded
      await precacheImage(networkImage.image, context);
      return networkImage;
    } catch (e) {
      if (retries > 0) {
        return await _loadImageWithRetry(url, retries - 1);
      } else {
        throw e; // After max retries, throw error
      }
    }
  }


  bool validateImage(){
    if(selectedImage != null){
      return true;
    }else{
      Get.snackbar(
        'Error',
        "Please select profile image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }
  }

  Future<void> registerUser() async {

    if(await isNetworkAvailable()){

      Loader.showLoading("Hype up! Creating your battleground");

      try{
        final response = await http.post(
          Uri.parse(AppUrl.registerUserApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(widget.userData),
        );

        print("Error during register body:${jsonEncode(widget.userData)}");
        print("Error during register code: ${response.statusCode}");
        if(response.statusCode == 201){


          Loader.hideLoading();
          Get.snackbar(
            'Success',
            "Account  successfully created",
            backgroundColor: Colors.green,
            colorText: Colors.black,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Login(),
          //   ),
          //
          // );
          Get.offAllNamed('/login');
        }else{
          final responseBody = jsonDecode(response.body); // Convert JSON string to Map
          final errorMessage = responseBody["message"];
          print("Error during register: $errorMessage");
          Loader.hideLoading();
          Get.snackbar(
            'Error',
            "$errorMessage",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
          );
        }
      }catch(e){
        print("Error during register catch: $e");
        Loader.hideLoading();
        Get.snackbar(
          'Error',
          "Error occurred!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 8,
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
        );
      }

    }else{
      Loader.hideLoading();
      Get.snackbar(
        'Error',
        "Internet not available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
    }

  }
  void hideSoftKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
