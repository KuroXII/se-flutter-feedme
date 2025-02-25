import 'package:flutter_feedme/blocs/order/order_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock_order_cubit.mocks.dart';

@GenerateMocks([
  OrderCubit,
])
void main() {}

OrderCubit mockOrderCubit({
  OrderState? orderState,
  Stream<OrderState>? orderStream,
  String? merchantId,
}) {
  final cubit = MockOrderCubit();

  OrderState state = orderState ?? OrderCubit.initial().state;

  final stream = orderStream?.asBroadcastStream() ??
      Stream.fromFuture(Future.value(state)).asBroadcastStream();

  when(cubit.stream).thenAnswer((_) => stream);
  when(cubit.state).thenReturn(state);

  return cubit;
}
