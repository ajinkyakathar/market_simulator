import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stock_row.dart';
import '../widgets/wallet_card.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MarketProvider>();

    return Column(
      children: [
        const WalletCard(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Live Prices',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: p.isRunning ? AppTheme.gain : AppTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    p.isRunning ? 'LIVE' : 'PAUSED',
                    style: TextStyle(
                      color: p.isRunning
                          ? AppTheme.gain
                          : AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: p.stocks.length,
            itemBuilder: (_, i) => StockRow(stock: p.stocks[i]),
          ),
        ),
      ],
    );
  }
}