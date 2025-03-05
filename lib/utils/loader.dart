import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Loader {
  static void showLoading([String description = '']) {
    Get.isSnackbarOpen ? Get.closeAllSnackbars() : null;
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          alignment: Alignment.center,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 250.0, // Adjusted height to accommodate both animations
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Stack to overlay the sparkles on top of the flying plane
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // The flying plane animation (ani2.json)
                        Lottie.asset(
                          'assets/animations/ani1.json', // Path to flying plane ani1 and ani2 is fire
                          fit: BoxFit.contain,
                        ),

                        // Sparkles animation (ani3.json) overlayed on top of the plane
                        Lottie.asset(
                          'assets/animations/ani3.json', // Path to sparkles animation
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description text below the animations
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Please wait...",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  static void hideLoading() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
