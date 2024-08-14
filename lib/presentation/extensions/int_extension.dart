import 'package:intl/intl.dart';

extension IntExtension on int {
  String toIDRCurrencyFormat() => NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(this);
}
