import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/presentation/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeBookingPage extends ConsumerStatefulWidget {
  final MovieDetail moviedetail;
  const TimeBookingPage(this.moviedetail, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimeBookingPageState();
}

class _TimeBookingPageState extends ConsumerState<TimeBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: SelectableCard(
            text: 'XXI Botanica',
            onTap: () {},
            isEnable: false,
            isSelected: false,
          ),
        ),
      ),
    );
  }
}
