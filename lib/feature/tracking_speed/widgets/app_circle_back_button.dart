// import 'package:flutter/material.dart';
//
//
// class AppCircleBackButton extends StatelessWidget {
//   const AppCircleBackButton({
//     Key? key,
//     required this.colors,
//     this.onBack,
//   }) : super(key: key);
//
//   final AppColors colors;
//   final VoidCallback? onBack;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Align(
//         alignment: Alignment.topLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(Spacing.l),
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: colors.strokeColor,
//                 width: 2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   offset: const Offset(0, 2),
//                   color: colors.strokeColor,
//                 ),
//               ],
//             ),
//             child: Material(
//               color: colors.primary,
//               shape: const CircleBorder(),
//               child: InkWell(
//                 onTap: onBack ?? () => Navigator.of(context).pop(),
//                 splashColor: colors.white,
//                 borderRadius: BorderRadius.circular(50),
//                 child: AppImage.svg(
//                   IconPath.back,
//                   color: colors.strokeColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
