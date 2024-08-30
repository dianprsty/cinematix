import 'package:cinematix/presentation/misc/method.dart';
import 'package:flutter/material.dart';

import '../misc/constant.dart';

class BottomNavBarItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String title;
  final String image;
  final String selectedImage;

  const BottomNavBarItem({
    super.key,
    required this.index,
    required this.isSelected,
    required this.title,
    required this.image,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25,
          width: 25,
          child: Image.asset(isSelected ? selectedImage : image),
        ),
        verticalSpace(4),
        Text(
          title,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isSelected ? saffron : ghostWhite,
          ),
        )
      ],
    );
  }
}
