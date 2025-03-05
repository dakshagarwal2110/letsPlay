import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsplay/auth/signup_stage3.dart';
import 'package:letsplay/auth/signupstage1.dart';

import '../utils/common_widgets.dart';
import 'login.dart';

class Signupstage2 extends StatefulWidget {

  final Map<String, String> userData;
  final String mobileNumber;
  const Signupstage2({super.key, required this.userData, required this.mobileNumber});

  @override
  State<Signupstage2> createState() => _Signupstage2State();
}

class _Signupstage2State extends State<Signupstage2> {

  final _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
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

                  SizedBox(height: 15,),

                  IconButton(onPressed: (){

                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Signup(),
                    //   ),
                    // );
                    Navigator.pop(context);

                  }, icon: Icon(Icons.arrow_back , color: Colors.white,)),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png', // Replace with your logo path
                      height: 150,
                    ),
                  ),

                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(
                          Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                      child: Text(
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

                  SizedBox(height: 30),

                  // SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Verify number",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mulish',

                      ),
                    ),
                  ),
                  SizedBox(height: 7),

                  Center(
                    child: Text(
                      widget.mobileNumber,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontWeight: FontWeight.normal,


                      ),
                    ),
                  ),

                  SizedBox(height: 30,),
                  EnterPincodeField(
                    onCompleted: (onCompletedValue) {

                    },
                    onChanged: (onChangedValue) {
                      print("value changed is: $onChangedValue");
                      //userController.otpNumber.value.text = onChangedValue;
                      // if (onChangedValue.length != 4) {
                      //   userController.isVerificationButton.value = false;
                      // }
                    },
                  ),
                  // Continue Button
                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity, // Adjust the width as per your layout
                    height: 50, // Adjust the height as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupStage3(userData: widget.userData,),
                          ),
                        );
                        // Your onPressed function
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16
                          , fontFamily: 'Mulish',// Font size
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
  void hideSoftKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
