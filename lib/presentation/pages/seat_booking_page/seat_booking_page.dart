import 'dart:math';

import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/presentation/extensions/build_context_extension.dart';
import 'package:cinematix/presentation/misc/constant.dart';
import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/pages/seat_booking_page/methods/legend.dart';
import 'package:cinematix/presentation/pages/seat_booking_page/methods/movie_screen.dart';
import 'package:cinematix/presentation/pages/seat_booking_page/methods/seat_section.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:cinematix/presentation/widgets/back_navigation_bar.dart';
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
  List<int> selectedSeat = [];
  List<int> reservedSeat = [];

  @override
  void initState() {
    super.initState();

    Random random = Random();
    int reservedNumber = random.nextInt(36) + 1;
    while (reservedSeat.length < 8) {
      if (!reservedSeat.contains(reservedNumber)) {
        reservedSeat.add(reservedNumber);
      }
      reservedNumber = random.nextInt(36) + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (moviedetail, transaction) = widget.transactionDetail;
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                BackNavigationBar(
                  title: moviedetail.title,
                  onTap: () {
                    ref.read(routerProvider).pop();
                  },
                ),
                movieScreen(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    seatSection(
                      seatNumbers: List.generate(18, (index) => index + 1),
                      onTap: onSeatTap,
                      seatStatusChecker: seatStatusChecker,
                    ),
                    horizontalSpace(30),
                    seatSection(
                      seatNumbers: List.generate(18, (index) => index + 19),
                      onTap: onSeatTap,
                      seatStatusChecker: seatStatusChecker,
                    ),
                  ],
                ),
                verticalSpace(20),
                legend(),
                verticalSpace(40),
                Text(
                  '${selectedSeat.length} seat(s) Selected',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedSeat.isEmpty) {
                        context.showSnackBar('Please select seat');
                      } else {
                        var updatedTransaction = transaction.copyWith(
                          seats: (selectedSeat..sort())
                              .map((e) => e.toString())
                              .toList(),
                          ticketAmount: selectedSeat.length,
                          ticketPrice: 25000,
                        );
                        ref.read(routerProvider).pushNamed(
                          'booking-confirmation',
                          extra: (moviedetail, updatedTransaction),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: backgroundColor,
                        backgroundColor: saffron,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: const Text("Next"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SeatStatus seatStatusChecker(seatNumber) => reservedSeat.contains(seatNumber)
      ? SeatStatus.reserved
      : selectedSeat.contains(seatNumber)
          ? SeatStatus.selected
          : SeatStatus.available;

  void onSeatTap(seatNumber) {
    if (!selectedSeat.contains(seatNumber)) {
      setState(() {
        selectedSeat.add(seatNumber);
      });
    } else {
      setState(() {
        selectedSeat.remove(seatNumber);
      });
    }
  }
}
