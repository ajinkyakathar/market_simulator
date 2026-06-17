import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/stock.dart';
import '../models/portfolio_holding.dart';
import '../models/transaction.dart';

class MarketProvider extends ChangeNotifier {
  final _random = Random();
  Timer? _timer;

  double balance = 10000.0;
  final List<Stock> stocks = [];
  final Map<String, PortfolioHolding> _portfolio = {};
  final List<Transaction> transactions = [];
  bool isRunning = false;

  MarketProvider() {
    _initStocks();
    _startTimer();
  }

  void _initStocks() {
    final data = [
      ('AAPL', 'Apple'),
      ('TSLA', 'Tesla'),
      ('AMZN', 'Amazon'),
      ('GOOGL', 'Google'),
      ('MSFT', 'Microsoft'),
    ];

    for (final (symbol, name) in data) {
      final price = 100 + _random.nextDouble() * 400;
      stocks.add(Stock(
        id: symbol,
        name: name,
        symbol: symbol,
        initialPrice: double.parse(price.toStringAsFixed(2)),
      ));
    }
  }

  void _startTimer() {
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _tick());
  }

  void _tick() {
    for (final stock in stocks) {
      final change = 1 + _random.nextDouble() * 19;
      final newPrice = _random.nextBool()
          ? stock.currentPrice + change
          : max(1.0, stock.currentPrice - change);
      stock.updatePrice(double.parse(newPrice.toStringAsFixed(2)));
    }
    notifyListeners();
  }

  void toggleMarket() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
    } else {
      _startTimer();
    }
    notifyListeners();
  }

  List<PortfolioHolding> get portfolio =>
      _portfolio.values.where((h) => h.quantity > 0).toList();

  int sharesOwned(String stockId) => _portfolio[stockId]?.quantity ?? 0;

  double get portfolioValue {
    double total = 0;
    for (final h in _portfolio.values) {
      final stock = stocks.firstWhere((s) => s.id == h.stockId);
      total += h.totalValue(stock.currentPrice);
    }
    return total;
  }


  String? buy(String stockId, int qty) {
    if (qty <= 0) return 'Enter a valid quantity';

    final stock = stocks.firstWhere((s) => s.id == stockId);
    final cost = stock.currentPrice * qty;

    if (cost > balance) {
      return 'Not enough balance';
    }

    balance -= cost;

    if (_portfolio.containsKey(stockId)) {
      final h = _portfolio[stockId]!;
      final newQty = h.quantity + qty;
      h.averageBuyPrice =
          ((h.averageBuyPrice * h.quantity) + cost) / newQty;
      h.quantity = newQty;
    } else {
      _portfolio[stockId] = PortfolioHolding(
        stockId: stockId,
        stockName: stock.name,
        stockSymbol: stock.symbol,
        quantity: qty,
        averageBuyPrice: stock.currentPrice,
      );
    }

    transactions.add(Transaction(
      stockId: stockId,
      stockName: stock.name,
      type: TransactionType.buy,
      quantity: qty,
      pricePerShare: stock.currentPrice,
      timestamp: DateTime.now(),
    ));

    notifyListeners();
    return null;
  }

  String? sell(String stockId, int qty) {
    if (qty <= 0) return 'Enter a valid quantity';

    final h = _portfolio[stockId];
    if (h == null || h.quantity < qty) {
      return 'You only own ${h?.quantity ?? 0} shares';
    }

    final stock = stocks.firstWhere((s) => s.id == stockId);
    balance += stock.currentPrice * qty;
    h.quantity -= qty;

    transactions.add(Transaction(
      stockId: stockId,
      stockName: stock.name,
      type: TransactionType.sell,
      quantity: qty,
      pricePerShare: stock.currentPrice,
      timestamp: DateTime.now(),
    ));

    notifyListeners();
    return null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}