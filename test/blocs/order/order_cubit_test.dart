import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_feedme/blocs/order/order_cubit.dart';
import 'package:flutter_feedme/model/bot_model.dart';
import 'package:flutter_feedme/model/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderCubit', () {
    late OrderCubit orderCubit;

    setUp(() {
      orderCubit = OrderCubit.initial();
    });

    tearDown(() {
      orderCubit.close();
    });

    test('Initial state should have no orders and no bots', () {
      final state = orderCubit.state;

      expect(state.pendingOrders, isEmpty);
      expect(state.completedOrders, isEmpty);
      expect(state.bots, isEmpty);
    });

    blocTest<OrderCubit, OrderState>(
      'Adding VIP and normal orders prioritizes VIP correctly',
      build: () => orderCubit,
      act: (cubit) {
        cubit.addOrder(OrderType.normal);
        cubit.addOrder(OrderType.vip);
        cubit.addOrder(OrderType.normal);
        cubit.addOrder(OrderType.vip);
      },
      expect: () => [
        isA<OrderManagementState>().having(
          (state) => state.pendingOrders.length,
          'should have 1 order',
          1,
        ),
        isA<OrderManagementState>().having(
          (state) => state.pendingOrders.map((o) => o.type).toList(),
          'VIP should be prioritized',
          [OrderType.vip, OrderType.normal],
        ),
        isA<OrderManagementState>().having(
          (state) => state.pendingOrders.map((o) => o.type).toList(),
          'Multiple orders should maintain VIP priority',
          [OrderType.vip, OrderType.normal, OrderType.normal],
        ),
        isA<OrderManagementState>().having(
          (state) => state.pendingOrders.map((o) => o.type).toList(),
          'VIP orders should be in front',
          [OrderType.vip, OrderType.vip, OrderType.normal, OrderType.normal],
        ),
      ],
    );

    blocTest<OrderCubit, OrderState>(
      'Adding a bot starts processing orders immediately',
      build: () => orderCubit,
      act: (cubit) async {
        cubit.addBot();
      },
      expect: () => [
        isA<OrderManagementState>().having(
          (state) => state.bots.first,
          'bot should be initialized correctly',
          isA<Bot>()
              .having((bot) => bot.id, 'id', 1)
              .having((bot) => bot.isProcessing, 'isProcessing', false),
        ),
      ],
    );

    blocTest<OrderCubit, OrderState>(
      'Removing a bot decreases bot count',
      build: () => orderCubit,
      act: (cubit) {
        cubit.addBot();
        cubit.addBot();
        cubit.removeBot();
      },
      expect: () => [
        isA<OrderManagementState>().having(
          (state) => state.bots.length,
          'should have 1 bot after first addition',
          1,
        ),
        isA<OrderManagementState>().having(
          (state) => state.bots.length,
          'should have 2 bots after second addition',
          2,
        ),
        isA<OrderManagementState>().having(
          (state) => state.bots.length,
          'should have 1 bot after removal',
          1,
        ),
      ],
    );

    blocTest<OrderCubit, OrderState>(
      'Orders complete after processing',
      build: () => orderCubit,
      act: (cubit) async {
        cubit.addOrder(OrderType.vip);
        cubit.addBot();
        await Future.delayed(
          const Duration(seconds: 11),
        ); // Wait for completion
      },
      verify: (cubit) {
        expect(cubit.state.completedOrders.length, 1);
        expect(cubit.state.pendingOrders.isEmpty, true);
      },
    );
  });
}
