class PortfolioHolding {
  final String stockId;
  final String stockName;
  final String stockSymbol;
  int quantity;
  double averageBuyPrice;

  PortfolioHolding({
    required this.stockId,
    required this.stockName,
    required this.stockSymbol,
    required this.quantity,
    required this.averageBuyPrice,
  });

  double totalValue(double currentPrice) => quantity * currentPrice;

  double profitLoss(double currentPrice) =>
      (currentPrice - averageBuyPrice) * quantity;
}