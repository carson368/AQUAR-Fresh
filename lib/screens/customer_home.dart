import 'package:flutter/material.dart';

import '../models/order.dart';
import '../models/product.dart';
import '../services/mock_store.dart';
import '../widgets/common.dart';
import 'welcome_screen.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KIU Fresh',
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
      body: IndexedStack(
        index: tab,
        children: const [
          _ShopTab(),
          _OrdersTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) {
          setState(() {
            tab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Water',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WATER / SHOP TAB
// -----------------------------------------------------------------------------

class _ShopTab extends StatelessWidget {
  const _ShopTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clean water, delivered.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Choose your refill and place an order in a few taps.',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          'Available water',
          subtitle: 'Demo catalogue — prices can later come from the backend.',
        ),
        const SizedBox(height: 14),
        ...MockStore.products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  child: Icon(Icons.local_drink_outlined),
                ),
                title: Text(
                  '${product.name} · ${product.size}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${product.description}\n'
                    'KSh ${product.price.toStringAsFixed(0)}',
                  ),
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(
                        product: product,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// CHECKOUT SCREEN
// -----------------------------------------------------------------------------

class CheckoutScreen extends StatefulWidget {
  final Product product;

  const CheckoutScreen({
    super.key,
    required this.product,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int qty = 1;

  final TextEditingController destination = TextEditingController();

  String payment = 'M-Pesa';

  @override
  void dispose() {
    destination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.product.price * qty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionTitle(
            '${widget.product.name} · ${widget.product.size}',
            subtitle: widget.product.description,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: qty > 1
                        ? () {
                            setState(() {
                              qty--;
                            });
                          }
                        : null,
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                  ),
                  Text(
                    '$qty',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        qty++;
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: destination,
            decoration: const InputDecoration(
              labelText: 'Delivery location',
              hintText: 'e.g. Main Campus Hostel',
              prefixIcon: Icon(
                Icons.location_on_outlined,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: payment,
            decoration: const InputDecoration(
              labelText: 'Payment method',
              prefixIcon: Icon(
                Icons.payments_outlined,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'M-Pesa',
                child: Text(
                  'M-Pesa (simulated)',
                ),
              ),
              DropdownMenuItem(
                value: 'Cash',
                child: Text('Cash'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  payment = value;
                });
              }
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Text(
                'KSh ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (destination.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Enter a delivery location.',
                    ),
                  ),
                );

                return;
              }

              MockStore.orders.insert(
                0,
                WaterOrder(
                  id: MockStore.nextOrderId(),
                  customerName: 'Demo Customer',
                  productName:
                      '${widget.product.name} · ${widget.product.size}',
                  quantity: qty,
                  total: total,
                  destination: destination.text.trim(),
                  status: payment == 'Cash'
                      ? OrderStatus.confirmed
                      : OrderStatus.awaitingPayment,
                ),
              );

              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text(
                      'Order created',
                    ),
                    content: Text(
                      payment == 'M-Pesa'
                          ? 'Your order was created. M-Pesa is simulated '
                              'in this MVP; no real payment was charged.'
                          : 'Your cash order has been created.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'Place order · KSh ${total.toStringAsFixed(0)}',
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ORDERS TAB
// -----------------------------------------------------------------------------

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    final customerOrders = MockStore.orders
        .where(
          (order) => order.customerName == 'Demo Customer',
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionTitle(
          'My orders',
          subtitle: 'Track your current and previous water orders.',
        ),
        const SizedBox(height: 14),
        ...customerOrders.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  order.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${order.productName} × ${order.quantity}\n'
                  '${order.destination}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KSh ${order.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      orderStatusLabel(order.status),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// PROFILE TAB
// -----------------------------------------------------------------------------

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        SectionTitle('Profile'),
        SizedBox(height: 16),
        InfoCard(
          icon: Icons.person_outline,
          label: 'Customer',
          value: 'Demo Customer',
        ),
        SizedBox(height: 12),
        InfoCard(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: '+254 7XX XXX XXX',
        ),
        SizedBox(height: 12),
        InfoCard(
          icon: Icons.location_on_outlined,
          label: 'Default area',
          value: 'Main Campus',
        ),
      ],
    );
  }
}
