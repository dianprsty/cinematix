import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/presentation/extensions/build_context_extension.dart';
import 'package:cinematix/presentation/misc/constant.dart';
import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/pages/time_booking_page/methods/options.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:cinematix/presentation/providers/user_data/user_data_provider.dart';
import 'package:cinematix/presentation/widgets/back_navigation_bar.dart';
import 'package:cinematix/presentation/widgets/network_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TimeBookingPage extends ConsumerStatefulWidget {
  final MovieDetail moviedetail;
  const TimeBookingPage(this.moviedetail, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimeBookingPageState();
}

class _TimeBookingPageState extends ConsumerState<TimeBookingPage> {
  final List<String> theaters = [
    'XXI the Botanica',
    'XXI Cihampelas Walk',
    'CGV Paris van Java',
    'CGV Paskal23',
  ];

  final List<DateTime> dates = List.generate(
    7,
    (index) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      return date.add(Duration(days: index));
    },
  );

  final List<int> hours = List.generate(8, (index) => index + 12);
  String? selectedTheater;
  DateTime? selectedDate;
  int? selectedHour;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: BackNavigationBar(
            title: widget.moviedetail.title,
            onTap: () {
              ref.read(routerProvider).pop();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: NetworkImageCard(
            width: MediaQuery.of(context).size.width - 48,
            height: (MediaQuery.of(context).size.width - 48) * 0.6,
            boxFit: BoxFit.cover,
            borderRadius: 15,
            imageUrl:
                'https://image.tmdb.org/t/p/w500${widget.moviedetail.backdropPath ?? widget.moviedetail.posterPath}',
          ),
        ),
        ...options(
          title: 'Select Theater',
          options: theaters,
          selectedItem: selectedTheater,
          onTap: (object) => setState(() {
            selectedTheater = object;
          }),
        ),
        verticalSpace(24),
        ...options(
            title: 'Select Date',
            options: dates,
            selectedItem: selectedDate,
            converter: (date) => DateFormat('EEE, d MMMM y').format(date),
            isOptionEnable: (object) => selectedTheater != null,
            onTap: (object) {
              setState(() {
                selectedDate = object;
              });
            }),
        verticalSpace(24),
        ...options(
          title: 'Select Hour',
          options: hours,
          selectedItem: selectedHour,
          converter: (object) => '$object:00',
          isOptionEnable: (hour) =>
              selectedDate != null &&
              DateTime(selectedDate!.year, selectedDate!.month,
                      selectedDate!.day, hour)
                  .isAfter(DateTime.now()),
          onTap: (object) => setState(() {
            selectedHour = object;
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ElevatedButton(
            onPressed: () {
              if (selectedTheater == null ||
                  selectedDate == null ||
                  selectedHour == null) {
                context.showSnackBar('Please select show schedule');
                return;
              }
              Transaction transaction = Transaction(
                uid: ref.read(userDataProvider).value!.uid,
                transactionImage: widget.moviedetail.posterPath,
                title: widget.moviedetail.title,
                adminFee: 3000,
                total: 0,
                watchingTime: DateTime(selectedDate!.year, selectedDate!.month,
                        selectedDate!.day, selectedHour!)
                    .millisecondsSinceEpoch,
                theaterName: selectedTheater!,
              );
              ref.read(routerProvider).pushNamed('seat-booking',
                  extra: (widget.moviedetail, transaction));
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: backgroundColor,
                backgroundColor: saffron,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text('Next'),
          ),
        )
      ],
    ));
  }
}
