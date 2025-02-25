import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feedme/blocs/order/order_cubit.dart';

class AppProvider extends StatefulWidget {
  const AppProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: const [],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OrderCubit>(
            create: (BuildContext context) => OrderCubit.initial(),
            lazy: false,
          ),
        ],
        child: widget.child,
      ),
    );
  }
}
