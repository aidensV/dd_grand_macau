import 'package:ddgrandmacau/SplashScreen.dart';
import 'package:ddgrandmacau/provider/HistoryProvider.dart';
import 'package:ddgrandmacau/provider/HomeProvider.dart';
import 'package:ddgrandmacau/provider/OrderProvider.dart';
import 'package:ddgrandmacau/provider/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
    ChangeNotifierProvider<HistoryProvider>(create: (_) => HistoryProvider()),
    ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
    ChangeNotifierProvider<TransactionProvider>(create: (_) => TransactionProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

