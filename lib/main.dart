import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/market_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarketProvider(),
      child: MaterialApp(
        title: 'Market Simulator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );
  }
}