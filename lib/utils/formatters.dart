import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _price = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String price(double value) => _price.format(value);

  static String change(double value) {
    final prefix = value >= 0 ? '+' : '';
    return '$prefix${_price.format(value)}';
  }
}