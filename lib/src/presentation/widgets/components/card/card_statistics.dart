import 'package:flutter/material.dart';

class CardStatistics extends StatelessWidget {
  final Color backgroundColor;
  final int number;
  final String title;
  final String orientation;

  const CardStatistics({
    Key? key,
    required this.backgroundColor,
    required this.number,
    required this.title,
    this.orientation = 'row',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Padding(
      padding: EdgeInsets.only(
        bottom: screenHeight * 0.02,
        right: isTablet ? screenWidth * 0.04 : 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.08,
          ),
          child: orientation == 'row'
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      number.toString(),
                      style: TextStyle(
                        fontSize:
                            isTablet ? screenWidth * 0.08 : screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: isTablet
                              ? screenWidth * 0.034
                              : screenWidth * 0.049,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      number.toString(),
                      style: TextStyle(
                        fontSize:
                            isTablet ? screenWidth * 0.08 : screenWidth * 0.13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.001),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isTablet
                            ? screenWidth * 0.034
                            : screenWidth * 0.049,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
