import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/order/order_cubit.dart';
import '../model/order_model.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderCubit orderCubit;
  final OrderStatus status;

  const OrderItemWidget({
    required this.orderCubit,
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      bloc: orderCubit,
      builder: (context, state) {
        final isPending = status == OrderStatus.pending;
        final pendingOrders =
            isPending ? state.pendingOrders : state.completedOrders;

        return ListView.builder(
          itemCount: pendingOrders.length,
          itemBuilder: (context, index) {
            final order = pendingOrders[index];
            final isVip = order.type == OrderType.vip;

            return ListTile(
              title: Text('Order #${order.id}'),
              subtitle: Text(
                isVip ? 'VIP Order' : 'Normal Order',
              ),
              leading: isPending
                  ? const Icon(Icons.timer)
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
            );
          },
        );
      },
    );
  }
}
