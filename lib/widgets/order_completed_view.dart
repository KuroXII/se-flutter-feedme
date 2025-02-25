import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/order/order_cubit.dart';
import '../model/order_model.dart';

class OrderCompletedView extends StatelessWidget {
  final OrderCubit orderCubit;

  const OrderCompletedView(
    this.orderCubit, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      bloc: orderCubit,
      builder: (context, state) {
        final completedOrders = state.completedOrders;

        return ListView.builder(
          itemCount: completedOrders.length,
          itemBuilder: (context, index) {
            final order = completedOrders[index];
            return ListTile(
              title: Text('Order #${order.id}'),
              subtitle: Text(
                order.type == OrderType.vip ? 'VIP Order' : 'Normal Order',
              ),
              leading: const Icon(
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
