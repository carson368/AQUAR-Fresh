import 'package:flutter/material.dart';

import '../configs/colors.dart';
import '../models/order.dart';
import '../services/mock_store.dart';
import '../widgets/common.dart';
import 'welcome_screen.dart';

class DeliveryHome extends StatefulWidget {
  const DeliveryHome({super.key});

  @override
  State<DeliveryHome> createState() => _DeliveryHomeState();
}

class _DeliveryHomeState extends State<DeliveryHome> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.two_wheeler_outlined, color: primaryColor, size: 24),
            SizedBox(width: 8),
            Text(
              'AQUAR Fresh Delivery',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: tab,
        children: [
          _ActiveDeliveriesTab(
            onUpdate: () => setState(() {}),
          ),
          const _PastDeliveriesTab(),
          const _DeliveryProfileTab(),
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
            icon: Icon(Icons.two_wheeler_outlined),
            selectedIcon: Icon(Icons.two_wheeler),
            label: 'Deliveries',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: ACTIVE DELIVERIES
// -----------------------------------------------------------------------------

class _ActiveDeliveriesTab extends StatelessWidget {
  final VoidCallback onUpdate;

  const _ActiveDeliveriesTab({required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final deliveries = MockStore.orders
        .where(
          (o) =>
              o.status == OrderStatus.outForDelivery ||
              o.status == OrderStatus.preparing ||
              o.status == OrderStatus.confirmed,
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          'Assigned Deliveries',
          subtitle: 'Orders requiring pickup or delivery',
        ),
        const SizedBox(height: 16),
        if (deliveries.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 48, color: successColor),
                  SizedBox(height: 12),
                  Text(
                    'All deliveries completed!',
                    style: TextStyle(color: textMuted),
                  ),
                ],
              ),
            ),
          ),
        ...deliveries.map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            o.id,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            orderStatusLabel(o.status),
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      o.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${o.productName} × ${o.quantity}',
                      style: const TextStyle(color: textMuted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            o.destination,
                            style: const TextStyle(color: textMuted, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (o.status != OrderStatus.outForDelivery)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.two_wheeler_outlined),
                        onPressed: () {
                          o.status = OrderStatus.outForDelivery;
                          onUpdate();
                        },
                        label: const Text('Start delivery'),
                      )
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          o.status = OrderStatus.delivered;
                          onUpdate();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order ${o.id} marked as delivered.'),
                            ),
                          );
                        },
                        label: const Text('Mark as delivered'),
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
// TAB 2: PAST DELIVERIES (HISTORY)
// -----------------------------------------------------------------------------

class _PastDeliveriesTab extends StatelessWidget {
  const _PastDeliveriesTab();

  @override
  Widget build(BuildContext context) {
    final completed = MockStore.orders
        .where((o) => o.status == OrderStatus.delivered)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          'Past Deliveries',
          subtitle: 'History of completed water drop-offs',
        ),
        const SizedBox(height: 16),
        if (completed.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: textMuted),
                  SizedBox(height: 12),
                  Text(
                    'No completed deliveries yet.',
                    style: TextStyle(color: textMuted),
                  ),
                ],
              ),
            ),
          ),
        ...completed.map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            o.id,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            orderStatusLabel(o.status),
                            style: const TextStyle(
                              color: successColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      o.customerName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${o.productName} × ${o.quantity}',
                      style: const TextStyle(color: textMuted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            o.destination,
                            style: const TextStyle(color: textMuted, fontSize: 13),
                          ),
                        ),
                        Text(
                          'KSh ${o.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
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
// TAB 3: DELIVERY RIDER PROFILE
// -----------------------------------------------------------------------------

class _DeliveryProfileTab extends StatelessWidget {
  const _DeliveryProfileTab();

  @override
  Widget build(BuildContext context) {
    final completedCount = MockStore.orders
        .where((o) => o.status == OrderStatus.delivered)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: const CircleAvatar(
              radius: 46,
              backgroundColor: secondaryColor,
              child: Icon(
                Icons.two_wheeler,
                size: 50,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Dennis Kipkorir',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'dennis.delivery@aquafresh.com',
            style: TextStyle(fontSize: 14, color: textMuted),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.badge_outlined,
                  label: 'Rider ID',
                  value: 'RDR-042',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: '+254 712 987 654',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.motorcycle_outlined,
                  label: 'Vehicle',
                  value: 'Motorcycle (KMD 342X)',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.location_on_outlined,
                  label: 'Assigned Zone',
                  value: 'Daystar Athi River / Lukenya',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.star_outline,
                  label: 'Performance Rating',
                  value: '4.9 ★  •  $completedCount completed today',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: textMuted),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          color: textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
