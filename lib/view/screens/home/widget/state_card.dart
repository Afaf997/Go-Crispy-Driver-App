import 'package:flutter/material.dart';

Widget buildStatCard(
    {required String title,
    required String count,
    required Color color,
    required double width,
    required double height,
    required double countFontSize,
    required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Container(
      width: width,
      //width: MediaQuery.of(context).size.width / 2.35,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: countFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
