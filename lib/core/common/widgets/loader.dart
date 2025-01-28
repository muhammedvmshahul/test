// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../constant/local/local_variables.dart';
//
//
// class LoaderClass{
//
//
//
//
//   Widget meterialShimmer1(){
//     return
//       Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12)
//         ),
//         width: scrWidth,
//         height: scrHeight*0.2,
//         child: ListView.builder(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: 4,
//             itemBuilder: (context,index) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14.0),
//                     ),
//                     width: scrWidth *0.2,
//                     height: scrHeight*0.2,
//                     child:
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: _buildCard(
//                         title: "Module 1 Little Lab",
//                         date: "11-10-2024",
//                         buttonText: "Read Summary",
//                         icon: Icons.favorite_border,
//                         backgroundColor: Colors.transparent,
//                       ),
//                     )
//                 ),
//               );
//             }
//         ),
//       ) ;
//
//
//
//
//   }
//
//   Widget meterialShimmer2(){
//     return
//       Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12)
//         ),
//         width: scrWidth,
//         height: scrHeight*0.2,
//         child: ListView.builder(
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemCount: 4,
//             itemBuilder: (context,index) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14.0),
//                     ),
//                     width: scrWidth *0.2,
//                     height: scrHeight*0.2,
//                     child:
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: _buildCard(
//                         title: "Module 1 Little Lab",
//                         date: "11-10-2024",
//                         buttonText: "Read Summary",
//                         icon: Icons.favorite_border,
//                         backgroundColor: Colors.transparent,
//                       ),
//                     )
//                 ),
//               );
//             }
//         ),
//       ) ;
//
//
//
//
//   }
//   // Widget meterialShimmer2(){
//   //   return  Shimmer.fromColors(
//   //     baseColor: Colors.grey[300]!,
//   //     highlightColor: Colors.grey[100]!,
//   //     child: _buildCard(
//   //       title: "ModelQuestion1",
//   //       date: "06-11-2024",
//   //       buttonText: "Read View",
//   //       icon: Icons.visibility,
//   //       backgroundColor: Color(0xFF033E6B), // Matches the dark blue color from the image
//   //     ),
//   //
//   //   );
//   // }
//
//
//   Widget _buildCard({
//     required String title,
//     required String date,
//     required String buttonText,
//     required IconData icon,
//     required Color backgroundColor,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(14.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6.0,
//             spreadRadius: 1.0,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   title,
//           //   style: TextStyle(
//           //     fontSize: 18,
//           //     fontWeight: FontWeight.bold,
//           //     color: backgroundColor == Colors.white ? Colors.black : Colors.white,
//           //   ),
//           // ),
//           // SizedBox(height: 8),
//           // Text(
//           //   date,
//           //   style: TextStyle(
//           //     fontSize: 14,
//           //     color: backgroundColor == Colors.white ? Colors.black54 : Colors.white70,
//           //   ),
//           // ),
//           // SizedBox(height: 12),
//
//         ],
//       ),
//     );
//   }
// }
//
//
