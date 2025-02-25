import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

enum OrderType { normal, vip }

enum OrderStatus { pending, complete }

@JsonSerializable()
class Order {
  final int id;
  final OrderType type;
  OrderStatus status;

  Order({
    required this.id,
    required this.type,
    this.status = OrderStatus.pending,
  });

  Order copyWith({
    final int? id,
    final OrderType? type,
    final OrderStatus? status,
  }) {
    return Order(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
