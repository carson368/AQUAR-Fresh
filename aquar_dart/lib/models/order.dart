enum OrderStatus { awaitingPayment, confirmed, preparing, outForDelivery, delivered, cancelled }

class WaterOrder {
  final String id;
  final String customerName;
  final String productName;
  final int quantity;
  final double total;
  final String destination;
  OrderStatus status;

  WaterOrder({required this.id, required this.customerName, required this.productName, required this.quantity, required this.total, required this.destination, required this.status});
}

String orderStatusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.awaitingPayment: return 'Awaiting payment';
    case OrderStatus.confirmed: return 'Confirmed';
    case OrderStatus.preparing: return 'Preparing';
    case OrderStatus.outForDelivery: return 'Out for delivery';
    case OrderStatus.delivered: return 'Delivered';
    case OrderStatus.cancelled: return 'Cancelled';
  }
}
