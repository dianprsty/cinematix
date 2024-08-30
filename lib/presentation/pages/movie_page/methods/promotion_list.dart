import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> promotionList(List<String> promotionImageFileName) => [
      Padding(
        padding: const EdgeInsets.only(left: 24, bottom: 15),
        child: Text(
          'Promotions',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: promotionImageFileName
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(
                    left: e == promotionImageFileName.first ? 24 : 10,
                    right: e == promotionImageFileName.last ? 24 : 0,
                  ),
                  child: Container(
                    width: 240,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/$e'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      )
    ];
