import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/stock.dart';
import '../providers/market_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class TradeSheet extends StatefulWidget {
  final Stock stock;
  const TradeSheet({super.key, required this.stock});

  @override
  State<TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends State<TradeSheet> {
  final _ctrl = TextEditingController(text: '1');
  bool _buying = true;

  int get _qty => int.tryParse(_ctrl.text) ?? 0;

  void _execute(BuildContext context) {
    final p = context.read<MarketProvider>();
    final error = _buying
        ? p.buy(widget.stock.id, _qty)
        : p.sell(widget.stock.id, _qty);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: AppTheme.loss,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '${_buying ? 'Bought' : 'Sold'} $_qty share(s) of ${widget.stock.name}'),
        backgroundColor: AppTheme.gain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MarketProvider>();
    final stock = p.stocks.firstWhere((s) => s.id == widget.stock.id);
    final owned = p.sharesOwned(stock.id);
    final total = stock.currentPrice * _qty;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(stock.symbol[0],
                    style: const TextStyle(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stock.name,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 17)),
                  Text(Formatters.price(stock.currentPrice),
                      style: const TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('You own',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 11)),
                  Text('$owned shares',
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _Tab(
                  label: 'BUY',
                  active: _buying,
                  color: AppTheme.gain,
                  onTap: () => setState(() => _buying = true),
                ),
                _Tab(
                  label: 'SELL',
                  active: !_buying,
                  color: AppTheme.loss,
                  onTap: () => setState(() => _buying = false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Quantity',
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              _QtyBtn(
                icon: Icons.remove,
                onTap: () {
                  if (_qty > 1) {
                    _ctrl.text = (_qty - 1).toString();
                    setState(() {});
                  }
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              _QtyBtn(
                icon: Icons.add,
                onTap: () {
                  _ctrl.text = (_qty + 1).toString();
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            color: AppTheme.textSecondary, fontSize: 11)),
                    Text(Formatters.price(total),
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Balance',
                        style: TextStyle(
                            color: AppTheme.textSecondary, fontSize: 11)),
                    Text(Formatters.price(p.balance),
                        style: const TextStyle(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _buying ? AppTheme.gain : AppTheme.loss,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _qty > 0 ? () => _execute(context) : null,
              child: Text(
                '${_buying ? 'Buy' : 'Sell'} $_qty Share${_qty == 1 ? '' : 's'}',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                color: active ? Colors.white : AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              )),
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.textPrimary, size: 20),
      ),
    );
  }
}