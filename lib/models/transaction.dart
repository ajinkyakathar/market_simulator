enum TransactionType { buy, sell }

class Transaction {
  final String stockId;
  final String stockName;
  final TransactionType type;
  final int quantity;
  final double pricePerShare;
  final DateTime timestamp;

  Transaction({
    required this.stockId,
    required this.stockName,
    required this.type,
    required this.quantity,
    required this.pricePerShare,
    required this.timestamp,
  });

  double get totalAmount => quantity * pricePerShare;

  String get typeLabel => type == TransactionType.buy ? 'BUY' : 'SELL';
}