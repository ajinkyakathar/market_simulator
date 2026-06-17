import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../utils/app_theme.dart';
import 'market_screen.dart';
import 'portfolio_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    MarketScreen(),
    PortfolioScreen(),
  ];

  final _titles = const ['Market', 'Portfolio'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.candlestick_chart_rounded,
                color: AppTheme.accent, size: 20),
            const SizedBox(width: 8),
            Text(_titles[_index]),
          ],
        ),
        actions: [
          Consumer<MarketProvider>(
            builder: (_, p, __) => IconButton(
              tooltip: p.isRunning ? 'Pause' : 'Resume',
              icon: Icon(
                p.isRunning
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                color: p.isRunning ? AppTheme.gain : AppTheme.textSecondary,
              ),
              onPressed: p.toggleMarket,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: AppTheme.accent),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon:
            Icon(Icons.pie_chart_rounded, color: AppTheme.accent),
            label: 'Portfolio',
          )
        ],
      ),
    );
  }
}