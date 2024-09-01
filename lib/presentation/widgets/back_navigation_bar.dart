import 'package:cinematix/presentation/misc/method.dart';
import 'package:flutter/material.dart';

class BackNavigationBar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const BackNavigationBar(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/images/back.png'),
          ),
        ),
        horizontalSpace(20),
        SizedBox(
          width: MediaQuery.of(context).size.width - 60 - 48,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
