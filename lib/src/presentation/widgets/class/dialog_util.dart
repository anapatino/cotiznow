import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogUtil {
  static void showConfirmationDialog({
    required String title,
    required String message,
    required String confirmButtonText,
    required Color backgroundConfirmButton,
    required String cancelButtonText,
    required Color backgroundCancelButton,
    required Color backgroundColor,
    required Function onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: GoogleFonts.varelaRound(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18.5,
      ),
      confirmTextColor: Colors.white,
      backgroundColor: backgroundColor,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              message,
              style: GoogleFonts.varelaRound(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundCancelButton,
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  cancelButtonText,
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundConfirmButton,
                ),
                onPressed: () {
                  Get.back();
                  onConfirm();
                },
                child: Text(
                  confirmButtonText,
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
