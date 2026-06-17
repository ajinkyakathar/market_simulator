import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stock.dart';
import '../providers/market_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import 'trade_sheet.dart';

class StockRow extends StatefulWidget {
  final Stock stock;
  const StockRow({super.key, required this.stock});

  @override
  State<StockRow> createState() => _StockRowState();
}

class _StockRowState extends State<StockRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Color?> _flash;
  double? _lastPrice;

  @override
  void initState() {
    super.initState();
    _lastPrice = widget.stock.currentPrice;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flash = ColorTween(begin: Colors.transparent, end: Colors.transparent)
        .animate(_ctrl);
  }

  @override
  void didUpdateWidget(StockRow old) {
    super.didUpdateWidget(old);
    if (_lastPrice != widget.stock.currentPrice) {
      final up = widget.stock.currentPrice > (_lastPrice ?? 0);
      _flash = ColorTween(
        begin: (up ? AppTheme.gain : AppTheme.loss).withOpacity(0.2),
        end: Colors.transparent,
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
      _ctrl.forward(from: 0);
      _lastPrice = widget.stock.currentPrice;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stock = widget.stock;
    final up = stock.isPositiveChange;
    final changeColor = up ? AppTheme.gain : AppTheme.loss;
    final owned = context.watch<MarketProvider>().sharesOwned(stock.id);

    return AnimatedBuilder(
      animation: _flash,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          color: _flash.value,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TradeSheet(stock: stock),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _Badge(letter: stock.symbol[0]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stock.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          )),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(stock.symbol,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              )),
                          if (owned > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$owned shares',
                                style: const TextStyle(
                                  color: AppTheme.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.price(stock.currentPrice),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          up
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 11,
                          color: changeColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          Formatters.change(stock.priceChange),
                          style: TextStyle(
                            color: changeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String letter;
  const _Badge({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: AppTheme.accent,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
    );
  }
}