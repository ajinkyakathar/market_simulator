class Stock {
  final String id;
  final String name;
  final String symbol;
  double currentPrice;
  double previousPrice;
  double priceChange;

  Stock({
    required this.id,
    required this.name,
    required this.symbol,
    required double initialPrice,
  })  : currentPrice = initialPrice,
        previousPrice = initialPrice,
        priceChange = 0.0;

  bool get isPositiveChange => priceChange >= 0;

  double get changePercent =>
      previousPrice == 0 ? 0 : (priceChange / previousPrice) * 100;

  void updatePrice(double newPrice) {
    previousPrice = currentPrice;
    currentPrice = newPrice;
    priceChange = currentPrice - previousPrice;
  }
}