import '../models/order.dart';
import '../models/product.dart';

class MockStore {
  static final products = <Product>[
    const Product(
      id: 'p1',
      name: 'Refill Water',
      size: '20 L',
      price: 100,
      description: 'Clean refilled drinking water for your 20 L container.',
      image: 'assets/images/refill_20l.png',
    ),
    const Product(
      id: 'p2',
      name: 'Refill Water',
      size: '10 L',
      price: 50,
      description: 'Convenient 10 L drinking-water refill.',
      image: 'assets/images/refill_10l.png',
    ),
    const Product(
      id: 'p3',
      name: 'Bottled Water',
      size: '1 L',
      price: 60,
      description: 'Sealed 1 L bottled drinking water.',
      image: 'assets/images/bottled_5l.png',
    ),
    const Product(
      id: 'p4',
      name: 'Bottled Water',
      size: '500 mL',
      price: 30,
      description: 'Sealed 500 ml bottled drinking water.',
      image: 'assets/images/bottled_5l.png',
    ),
    const Product(
      id: 'p5',
      name: 'Water-Dispenser Container',
      size: '20 L',
      price: 300,
      description: 'Empty 20 l Water-Dispenser Container.',
      image: 'assets/images/bottled_5l.png',
    ),
    const Product(
      id: 'p6',
      name: 'Water-Dispenser Container',
      size: '10 L',
      price: 150,
      description: 'Empty 10 l Water-Dispenser Container.',
      image: 'assets/images/bottled_5l.png',
    ),
  ];

  static final orders = <WaterOrder>[
    WaterOrder(id: 'KF-1042', customerName: 'Demo Customer', productName: 'Refill Water · 20 L', quantity: 2, total: 200, destination: 'Main Campus Hostel', status: OrderStatus.preparing),
    WaterOrder(id: 'KF-1039', customerName: 'Amina', productName: 'Refill Water · 10 L', quantity: 1, total: 60, destination: 'Student Centre', status: OrderStatus.outForDelivery),
    WaterOrder(id: 'KF-1035', customerName: 'Brian Kiprop', productName: 'Bottled Water · 5 L', quantity: 2, total: 360, destination: 'Faculty Block B', status: OrderStatus.delivered),
  ];

  static String nextOrderId() => 'KF-${1043 + orders.length}';
}
