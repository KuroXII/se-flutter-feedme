import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feedme/ui/order_management_screen.dart';

import 'blocs/order/order_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => OrderCubit.initial(),
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
