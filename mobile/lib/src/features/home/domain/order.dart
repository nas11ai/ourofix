// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Orders with _$Orders {
  const factory Orders({
    @JsonKey(name: "orders") required List<Order> orders,
  }) = _Orders;

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "response_midtrans") required String? responseMidtrans,
    @JsonKey(name: "status_transaksi") required String statusTransaksi,
    @JsonKey(name: "device_type") required DeviceType deviceType,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class DeviceType with _$DeviceType {
  const factory DeviceType({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
  }) = _DeviceType;

  factory DeviceType.fromJson(Map<String, dynamic> json) =>
      _$DeviceTypeFromJson(json);
}
