import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/widgets/network_image_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ticket extends StatelessWidget {
  final Transaction transaction;
  const Ticket({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF252836),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Text(
              transaction.id!,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: NetworkImageCard(
                  width: 75,
                  height: 114,
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${transaction.transactionImage}',
                  boxFit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    verticalSpace(10),
                    Text(
                      transaction.theaterName!,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy | HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              transaction.watchingTime!)),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    verticalSpace(10),
                    Text(
                      '${transaction.ticketAmount} Ticket(s) ${transaction.seats.join(', ')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
