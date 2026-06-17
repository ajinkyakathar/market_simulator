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

  static String percent(double value) {
    final prefix = value >= 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(2)}%';
  }

  static String time(DateTime dt) {
    return '${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}