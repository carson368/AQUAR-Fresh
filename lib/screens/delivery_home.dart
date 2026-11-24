import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/mock_store.dart';
import '../widgets/common.dart';
import 'welcome_screen.dart';

class DeliveryHome extends StatefulWidget { const DeliveryHome({super.key}); @override State<DeliveryHome> createState() => _DeliveryHomeState(); }
class _DeliveryHomeState extends State<DeliveryHome> {
  @override Widget build(BuildContext context) {
    final deliveries = MockStore.orders.where((o) => o.status == OrderStatus.outForDelivery || o.status == OrderStatus.preparing || o.status == OrderStatus.confirmed).toList();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
            title: const Text(
                'Deliveries', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [IconButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false), icon: const Icon(Icons.logout))]), body: ListView(padding: const EdgeInsets.all(20), children: [
      const SectionTitle('Assigned deliveries', subtitle: 'All Deliveries '), const SizedBox(height: 16),
      if (deliveries.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No active deliveries.'))),
      ...deliveries.map((o) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(o.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), Chip(label: Text(orderStatusLabel(o.status)))]), Text(o.customerName), const SizedBox(height: 4), Text('${o.productName} × ${o.quantity}'), const SizedBox(height: 8), Row(children: [const Icon(Icons.location_on_outlined, size: 18), const SizedBox(width: 6), Expanded(child: Text(o.destination))]), const SizedBox(height: 14),
        if (o.status != OrderStatus.outForDelivery) OutlinedButton(onPressed: () => setState(() => o.status = OrderStatus.outForDelivery), child: const Text('Start delivery')) else ElevatedButton(onPressed: () => setState(() => o.status = OrderStatus.delivered), child: const Text('Mark as delivered'))
      ])))))
    ]));
  }
}
