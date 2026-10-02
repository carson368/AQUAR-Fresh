import '../models/order.dart';
import '../models/product.dart';

class MockStore {
  static final products = <Product>[
    const Product(id: 'p1', name: 'Refill Water', size: '20 L', price: 100, description: 'Clean refilled drinking water for your 20 L container.'),
    const Product(id: 'p2', name: 'Refill Water', size: '10 L', price: 60, description: 'Convenient 10 L drinking-water refill.'),
    const Product(id: 'p3', name: 'Bottled Water', size: '5 L', price: 180, description: 'Sealed 5 L bottled drinking water.'),
  ];

  static final orders = <WaterOrder>[
    WaterOrder(id: 'KF-1042', customerName: 'Demo Customer', productName: 'Refill Water · 20 L', quantity: 2, total: 200, destination: 'Main Campus Hostel', status: OrderStatus.preparing),
    WaterOrder(id: 'KF-1039', customerName: 'Amina', productName: 'Refill Water · 10 L', quantity: 1, total: 60, destination: 'Student Centre', status: OrderStatus.outForDelivery),
  ];

  static String nextOrderId() => 'KF-${1043 + orders.length}';
}
