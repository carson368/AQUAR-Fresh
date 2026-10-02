import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/mock_store.dart';
import '../widgets/common.dart';
import 'welcome_screen.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final active = MockStore.orders
        .where(
          (o) =>
              o.status != OrderStatus.delivered &&
              o.status != OrderStatus.cancelled,
        )
        .length;

    final revenue = MockStore.orders
        .where(
          (o) =>
              o.status != OrderStatus.cancelled &&
              o.status != OrderStatus.awaitingPayment,
        )
        .fold<double>(0, (sum, order) => sum + order.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const WelcomeScreen(),
                ),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle(
            'Business overview',
            subtitle: 'Operational snapshot from local demo data.',
          ),
          const SizedBox(height: 16),
          InfoCard(
            icon: Icons.receipt_long,
            label: 'Active orders',
            value: '$active',
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.payments_outlined,
            label: 'Recorded revenue',
            value: 'KSh ${revenue.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            value: '${MockStore.products.length}',
          ),
          const SizedBox(height: 28),
          const SectionTitle('Orders requiring attention'),
          const SizedBox(height: 12),
          ...MockStore.orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text(
                    '${order.id} · ${order.customerName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${order.productName} × ${order.quantity}\n'
                    '${order.destination}',
                  ),
                  trailing: PopupMenuButton<OrderStatus>(
                    onSelected: (status) {
                      setState(() {
                        order.status = status;
                      });
                    },
                    itemBuilder: (_) => OrderStatus.values
                        .map(
                          (status) => PopupMenuItem<OrderStatus>(
                            value: status,
                            child: Text(
                              orderStatusLabel(status),
                            ),
                          ),
                        )
                        .toList(),
                    child: Chip(
                      label: Text(
                        orderStatusLabel(order.status),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
