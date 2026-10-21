import '../../home/data/menu_data.dart';

class OrderLine {
  const OrderLine({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  int get total => item.price * quantity;
}

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.placedAt,
    required this.lines,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.status,
  });

  final String id;
  final DateTime placedAt;
  final List<OrderLine> lines;
  final String customerName;
  final String phone;
  final String address;
  final String paymentMethod;
  final int subtotal;
  final int deliveryFee;
  final String status;

  int get total => subtotal + deliveryFee;

  CustomerOrder withStatus(String nextStatus) => CustomerOrder(
    id: id,
    placedAt: placedAt,
    lines: lines,
    customerName: customerName,
    phone: phone,
    address: address,
    paymentMethod: paymentMethod,
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    status: nextStatus,
  );
}
