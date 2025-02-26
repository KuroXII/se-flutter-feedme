import 'package:flutter/material.dart';
import 'package:flutter_feedme/app_provider.dart';
import 'package:flutter_feedme/ui/order_management_screen.dart';

void main() {
  runApp(
    AppProvider(
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.amberAccent,
          ),
        ),
        home: const OrderManagementScreen(),
      ),
    ),
  );
}
