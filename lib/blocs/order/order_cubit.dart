import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../model/bot_model.dart';
import '../../model/order_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  int _orderId = 1;
  int _botId = 1;
  final Set<int> _processingOrderIds = {};

  OrderCubit._({OrderState? state})
      : super(
          const OrderManagementState(
            pendingOrders: [],
            completedOrders: [],
            bots: [],
          ),
        );

  factory OrderCubit.initial({OrderState? state}) {
    // This use case is used to register only happen when mock cubit in test case
    if (GetIt.I.isRegistered<OrderCubit>()) {
      return GetIt.I.get<OrderCubit>();
    }

    return OrderCubit._(state: state);
  }

  void addOrder(OrderType type) {
    final newOrder = Order(
      id: _orderId++,
      type: type,
      status: OrderStatus.pending,
    );

    List<Order> updatedPendingOrders = List.from(state.pendingOrders);

    // Prioritize VIP orders while maintaining FIFO order
    if (type == OrderType.vip) {
      int insertIndex = updatedPendingOrders
          .lastIndexWhere((order) => order.type == OrderType.vip);

      if (insertIndex == -1) {
        updatedPendingOrders.insert(0, newOrder);
      } else {
        updatedPendingOrders.insert(insertIndex + 1, newOrder);
      }
    } else {
      updatedPendingOrders.add(newOrder);
    }

    emit(
      OrderManagementState(
        pendingOrders: updatedPendingOrders,
        completedOrders: state.completedOrders,
        bots: state.bots,
      ),
    );

    _processOrders();
  }

  void addBot() {
    List<Bot> updatedBots = List.from(state.bots)
      ..add(
        Bot(
          id: _botId++,
          isProcessing: false,
        ),
      );

    emit(
      OrderManagementState(
        pendingOrders: state.pendingOrders,
        completedOrders: state.completedOrders,
        bots: updatedBots,
      ),
    );

    _processOrders();
  }

  void removeBot() {
    if (state.bots.isEmpty) return;

    List<Bot> updatedBots = List.from(state.bots);
    Bot lastBot = updatedBots.removeLast();

    if (lastBot.isProcessing) {
      lastBot.isProcessing = false;
    }

    emit(
      OrderManagementState(
        pendingOrders: state.pendingOrders,
        completedOrders: state.completedOrders,
        bots: updatedBots,
      ),
    );
  }

  void _processOrders() {
    List<Bot> bots = state.bots;

    if (bots.isEmpty) return;

    for (var bot in bots) {
      _assignOrderToBot(bot);
    }
  }

  void _assignOrderToBot(Bot bot) {
    if (bot.isProcessing || state.pendingOrders.isEmpty) return;

    // Find the next available order (not assigned to another bot)
    Order? order;

    for (var pendingOrder in state.pendingOrders) {
      if (!_processingOrderIds.contains(pendingOrder.id)) {
        order = pendingOrder;
        break;
      }
    }

    if (order == null) return;

    // Mark order as being processed
    _processingOrderIds.add(order.id);

    bot.isProcessing = true;

    //  Keep the order in pendingOrders until completion and update bot status
    emit(
      OrderManagementState(
        pendingOrders: state.pendingOrders,
        completedOrders: state.completedOrders,
        bots: state.bots.map((b) => b.id == bot.id ? bot : b).toList(),
      ),
    );

    // Simulate processing time
    Future.delayed(const Duration(seconds: 10), () {
      order!.status = OrderStatus.complete;

      // Ensure order is not duplicated in completedOrders
      List<Order> updatedCompletedOrders = List.from(state.completedOrders);
      if (!updatedCompletedOrders.any(
          (updatedCompletedOrder) => updatedCompletedOrder.id == order!.id)) {
        updatedCompletedOrders.add(order);
      }

      bot.isProcessing = false;

      // Remove from processing list and pendingOrders
      _processingOrderIds.remove(order.id);

      List<Order> updatedPendingOrders = List.from(state.pendingOrders)
        ..removeWhere((pendingOrder) => pendingOrder.id == order!.id);

      emit(
        OrderManagementState(
          pendingOrders: updatedPendingOrders,
          completedOrders: updatedCompletedOrders,
          bots: state.bots.map((b) => b.id == bot.id ? bot : b).toList(),
        ),
      );

      _processOrders(); // Continue processing
    });
  }
}
