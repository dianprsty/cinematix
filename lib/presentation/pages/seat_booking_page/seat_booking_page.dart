import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/widgets/seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeatBookingPage extends ConsumerStatefulWidget {
  final (MovieDetail, Transaction) transactionDetail;
  const SeatBookingPage({super.key, required this.transactionDetail});

  @override
  ConsumerState<SeatBookingPage> createState() => _SeatBookingPageState();
}

class _SeatBookingPageState extends ConsumerState<SeatBookingPage> {
  @override
  Widget build(BuildContext context) {
    final (moviedetail, transaction) = widget.transactionDetail;
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Seat(
              number: 1,
              status: SeatStatus.reserved,
              onTap: () {},
            ),
            horizontalSpace(16),
            Seat(
              number: 2,
              status: SeatStatus.available,
              onTap: () {},
            ),
            horizontalSpace(16),
            Seat(
              number: 3,
              status: SeatStatus.selected,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
