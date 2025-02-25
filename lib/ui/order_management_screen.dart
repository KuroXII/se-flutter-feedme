import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/order/order_cubit.dart';
import '../model/order_model.dart';
import '../widgets/order_item_view.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  late OrderCubit _orderCubit;

  @override
  void initState() {
    super.initState();

    _orderCubit = OrderCubit.initial();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<OrderCubit, OrderState>(
            bloc: _orderCubit,
            builder: (context, state) {
              return Text('Order Management (Bots: ${state.bots.length})');
            },
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'addBot':
                    _orderCubit.addBot();
                    break;
                  case 'removeBot':
                    _orderCubit.removeBot();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'addBot',
                  child: Text("Add Bot"),
                ),
                const PopupMenuItem(
                  value: 'removeBot',
                  child: Text("Remove Bot"),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return TabBarView(
              children: [
                OrderItemWidget(
                  orderCubit: _orderCubit,
                  status: OrderStatus.pending,
                ),
                OrderItemWidget(
                  orderCubit: _orderCubit,
                  status: OrderStatus.complete,
                ),
              ],
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () => _orderCubit.addOrder(OrderType.vip),
              icon: const Icon(Icons.star),
              label: const Text("VIP Order"),
              backgroundColor: Colors.amber,
            ),
            const SizedBox(height: 12),
            FloatingActionButton.extended(
              onPressed: () => _orderCubit.addOrder(OrderType.normal),
              icon: const Icon(Icons.fastfood),
              label: const Text("New Order"),
            ),
          ],
        ),
      ),
    );
  }
}
