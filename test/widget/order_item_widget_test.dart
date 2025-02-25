import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feedme/blocs/order/order_cubit.dart';
import 'package:flutter_feedme/model/order_model.dart';
import 'package:flutter_feedme/widgets/order_item_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/blocs/order/mock_order_cubit.dart';

void main() {
  group('OrderItemWidget', () {
    late OrderCubit orderCubit;

    setUp(() {
      orderCubit = mockOrderCubit();
    });

    testWidgets('Displays a list of pending orders correctly',
        (WidgetTester tester) async {
      final orders = [
        Order(id: 1, type: OrderType.vip, status: OrderStatus.pending),
        Order(id: 2, type: OrderType.normal, status: OrderStatus.pending),
      ];

      await _pumpWidget(
        tester,
        orderCubit: orderCubit,
        orderState: OrderManagementState(
          pendingOrders: orders,
          completedOrders: const [],
          bots: const [],
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(2));

      expect(find.byIcon(Icons.timer), findsNWidgets(2));
      expect(find.byIcon(Icons.check_circle), findsNothing);

      expect(find.text('Order #1'), findsOneWidget);
      expect(find.text('VIP Order'), findsOneWidget);
      expect(find.text('Order #2'), findsOneWidget);
      expect(find.text('Normal Order'), findsOneWidget);
    });

    testWidgets('Displays a list of completed orders correctly',
        (WidgetTester tester) async {
      final orders = [
        Order(id: 3, type: OrderType.vip, status: OrderStatus.complete),
        Order(id: 4, type: OrderType.normal, status: OrderStatus.complete),
      ];

      await _pumpWidget(
        tester,
        orderCubit: orderCubit,
        status: OrderStatus.complete,
        orderState: OrderManagementState(
          pendingOrders: const [],
          completedOrders: orders,
          bots: const [],
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(2));

      expect(find.byIcon(Icons.timer), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));

      expect(find.text('Order #3'), findsOneWidget);
      expect(find.text('VIP Order'), findsOneWidget);
      expect(find.text('Order #4'), findsOneWidget);
      expect(find.text('Normal Order'), findsOneWidget);
    });

    testWidgets('Displays no orders when there are none',
        (WidgetTester tester) async {
      await _pumpWidget(tester, orderCubit: orderCubit);

      expect(find.byType(ListTile), findsNothing);

      expect(find.byIcon(Icons.timer), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });
  });
}

Future<void> _pumpWidget(
  WidgetTester tester, {
  required OrderCubit orderCubit,
  OrderStatus status = OrderStatus.pending,
  OrderState? orderState,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  orderCubit = mockOrderCubit(orderState: orderState);

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<OrderCubit>.value(
        value: orderCubit,
        child: Scaffold(
          body: OrderItemWidget(
            orderCubit: orderCubit,
            status: status,
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
