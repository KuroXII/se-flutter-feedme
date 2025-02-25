import 'package:flutter/material.dart';
import 'package:flutter_feedme/blocs/order/order_cubit.dart';
import 'package:flutter_feedme/model/bot_model.dart';
import 'package:flutter_feedme/model/order_model.dart';
import 'package:flutter_feedme/ui/order_management_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/blocs/order/mock_order_cubit.dart';

void main() {
  group('OrderManagementScreen Tests', () {
    late OrderCubit orderCubit;

    setUp(() {
      orderCubit = mockOrderCubit();
    });

    tearDown(() {
      // Unregister OrderCubit before each test
      if (GetIt.I.isRegistered<OrderCubit>()) {
        GetIt.I.unregister<OrderCubit>();
      }
    });

    testWidgets('UI display correctly', (WidgetTester tester) async {
      await _pumpPage(
        tester,
        orderCubit: orderCubit,
      );

      expect(find.text('Order Management (Bots: 0)'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('VIP Order'), findsOneWidget);
      expect(find.text('New Order'), findsOneWidget);

      expect(find.text('Order Management (Bots: 0)'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);

      expect(find.byType(FloatingActionButton), findsNWidgets(2));

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.fastfood), findsOneWidget);
    });

    testWidgets('should display correct title with bot count',
        (WidgetTester tester) async {
      await _pumpPage(
        tester,
        orderCubit: mockOrderCubit(
          orderState: OrderManagementState(
            pendingOrders: const [],
            completedOrders: const [],
            bots: [
              Bot(id: 1, isProcessing: false),
              Bot(id: 2, isProcessing: false)
            ],
          ),
        ),
      );

      expect(find.text('Order Management (Bots: 2)'), findsOneWidget);
    });

    group("UI actions", () {
      testWidgets('should call addBot when add bot is selected from popup menu',
          (WidgetTester tester) async {
        await _pumpPage(tester, orderCubit: orderCubit);

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add Bot'));
        await tester.pumpAndSettle();

        verify(orderCubit.addBot()).called(1);
      });

      testWidgets(
          'should call removeBot when remove bot is selected from popup menu',
          (WidgetTester tester) async {
        await _pumpPage(
          tester,
          orderCubit: orderCubit,
        );

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Remove Bot'));
        await tester.pumpAndSettle();

        verify(orderCubit.removeBot()).called(1);
      });

      testWidgets('should add VIP order when VIP Order button is pressed',
          (WidgetTester tester) async {
        await _pumpPage(
          tester,
          orderCubit: orderCubit,
        );

        await tester.tap(find.text('VIP Order'));
        await tester.pumpAndSettle();

        verify(orderCubit.addOrder(OrderType.vip)).called(1);
      });

      testWidgets('should add normal order when New Order button is pressed',
          (WidgetTester tester) async {
        await _pumpPage(
          tester,
          orderCubit: orderCubit,
        );

        await tester.tap(find.text('New Order'));
        await tester.pumpAndSettle();

        verify(orderCubit.addOrder(OrderType.normal)).called(1);
      });
    });
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  OrderCubit? orderCubit,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerLazySingleton<OrderCubit>(
    () => orderCubit ?? mockOrderCubit(),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<OrderCubit>.value(
        value: orderCubit ?? mockOrderCubit(),
        child: const Scaffold(
          body: OrderManagementScreen(),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
