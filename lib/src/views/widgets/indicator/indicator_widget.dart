// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:sellout_team/src/constants/constants.dart';

// class IndicatorWidget extends StatelessWidget {
//   final CarouselController controller;
//   final List list;
//   final int currentIndex;
//   IndicatorWidget(
//       {required this.controller,
//       required this.list,
//       required this.currentIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: list.asMap().entries.map((entry) {
//         return GestureDetector(
//           onTap: () => controller.animateToPage(entry.key),
//           child: Container(
//             width: 12.0,
//             height: 12.0,
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color:
//                     currentIndex == entry.key ? kPrimaryColor : Colors.white),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
