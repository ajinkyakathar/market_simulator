import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/wallet_card.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MarketProvider>();
    final holdings = p.portfolio;

    return Column(
      children: [
        const WalletCard(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Holdings',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              Text('${holdings.length} position${holdings.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
            ],
          ),
        ),
        Expanded(
          child: holdings.isEmpty
              ? const _Empty()
              : ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: holdings.length,
            itemBuilder: (_, i) {
              final h = holdings[i];
              final stock =
              p.stocks.firstWhere((s) => s.id == h.stockId);
              final pnl = h.profitLoss(stock.currentPrice);
              final isProfit = pnl >= 0;

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(h.stockSymbol[0],
                            style: const TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h.stockName,
                                style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                            const SizedBox(height: 3),
                            Text(
                              '${h.quantity} shares · avg ${Formatters.price(h.averageBuyPrice)}',
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatters.price(
                                h.totalValue(stock.currentPrice)),
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                isProfit
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                size: 13,
                                color: isProfit
                                    ? AppTheme.gain
                                    : AppTheme.loss,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                Formatters.change(pnl),
                                style: TextStyle(
                                    color: isProfit
                                        ? AppTheme.gain
                                        : AppTheme.loss,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pie_chart_outline_rounded,
                color: AppTheme.accent, size: 30),
          ),
          const SizedBox(height: 16),
          const Text('No positions yet',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text('Buy stocks from the Market tab',
              style:
              TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}