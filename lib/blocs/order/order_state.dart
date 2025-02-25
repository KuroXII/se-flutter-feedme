part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  final List<Order> pendingOrders;
  final List<Order> completedOrders;
  final List<Bot> bots;

  const OrderState({
    required this.pendingOrders,
    required this.completedOrders,
    required this.bots,
  });

  @override
  List<Object> get props => [
        pendingOrders,
        completedOrders,
        bots,
      ];
}

// State for pending orders
class OrderManagementState extends OrderState {
  const OrderManagementState({
    required List<Order> pendingOrders,
    required List<Order> completedOrders,
    required List<Bot> bots,
  }) : super(
          pendingOrders: pendingOrders,
          completedOrders: completedOrders,
          bots: bots,
        );
}
