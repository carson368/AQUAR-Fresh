import 'package:flutter/material.dart';

import '../configs/colors.dart';
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
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: primaryColor, size: 24),
            SizedBox(width: 8),
            Text(
              'AQUAR Fresh Admin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: tab,
        children: const [
          _DashboardTab(),
          _ProductsTab(),
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
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
// TAB 1: DASHBOARD
// -----------------------------------------------------------------------------

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Greeting
          const Text(
            "Welcome back, Admin 👋",
            style: TextStyle(
              fontSize: 20,
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Here is today's water station operations overview.",
            style: TextStyle(color: textMuted, fontSize: 13),
          ),

          const SizedBox(height: 20),

          // KPI Cards (Row 1)
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: 'Total Orders',
                  value: '128',
                  icon: Icons.shopping_bag_outlined,
                  iconColor: primaryColor,
                  bgColor: secondaryColor,
                  trend: '+12% this week',
                  trendColor: successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKpiCard(
                  title: 'Active Products',
                  value: '${MockStore.products.length}',
                  icon: Icons.inventory_2_outlined,
                  iconColor: const Color(0xFF6366F1), // Indigo
                  bgColor: const Color(0xFFEEF2FF),
                  trend: 'All in stock',
                  trendColor: primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // KPI Cards (Row 2)
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: 'Total Revenue',
                  value: 'KSh 12,300',
                  icon: Icons.payments_outlined,
                  iconColor: successColor,
                  bgColor: const Color(0xFFECFDF5),
                  trend: '+8% vs yesterday',
                  trendColor: successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKpiCard(
                  title: 'Customers',
                  value: '76',
                  icon: Icons.people_outline,
                  iconColor: warningColor,
                  bgColor: const Color(0xFFFFFBEB),
                  trend: '+5 this week',
                  trendColor: successColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity Header
          const SectionTitle(
            'Recent Orders Activity',
            subtitle: 'Latest transactions from customer app',
          ),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                _buildActivityTile(
                  orderId: '#1023',
                  subtitle: 'Fresh Water (20L) × 1',
                  amount: 'KSh 200',
                  timeAgo: '2m ago',
                  status: 'Pending',
                  statusColor: warningColor,
                  icon: Icons.hourglass_top,
                ),
                const Divider(height: 1),
                _buildActivityTile(
                  orderId: '#1022',
                  subtitle: 'Fresh Water (20L) × 2',
                  amount: 'KSh 400',
                  timeAgo: '15m ago',
                  status: 'Delivered',
                  statusColor: successColor,
                  icon: Icons.check_circle_outline,
                ),
                const Divider(height: 1),
                _buildActivityTile(
                  orderId: '#1021',
                  subtitle: 'Fresh Water (10L) × 1',
                  amount: 'KSh 100',
                  timeAgo: '1h ago',
                  status: 'Delivered',
                  statusColor: successColor,
                  icon: Icons.check_circle_outline,
                ),
                const Divider(height: 1),
                _buildActivityTile(
                  orderId: '#1020',
                  subtitle: 'Bottled Water (5L) × 1',
                  amount: 'KSh 180',
                  timeAgo: '2h ago',
                  status: 'Cancelled',
                  statusColor: dangerColor,
                  icon: Icons.cancel_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String trend,
    required Color trendColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: trendColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(color: textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile({
    required String orderId,
    required String subtitle,
    required String amount,
    required String timeAgo,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: statusColor, size: 20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            orderId,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: textMuted),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: PRODUCTS CATALOG
// -----------------------------------------------------------------------------

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          'Product Catalog',
          subtitle: 'Available water inventory & pricing.',
        ),
        const SizedBox(height: 16),
        ...MockStore.products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: product.image != null
                      ? Image.asset(
                          product.image!,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 54,
                            height: 54,
                            color: secondaryColor,
                            child: const Icon(Icons.water_drop, color: primaryColor),
                          ),
                        )
                      : Container(
                          width: 54,
                          height: 54,
                          color: secondaryColor,
                          child: const Icon(Icons.water_drop, color: primaryColor),
                        ),
                ),
                title: Text(
                  '${product.name} · ${product.size}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${product.description}\nPrice: KSh ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(color: textMuted, fontSize: 12),
                  ),
                ),
                isThreeLine: true,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.available
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.available ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(
                      color: product.available ? successColor : dangerColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
// TAB 3: ORDERS MANAGEMENT
// -----------------------------------------------------------------------------

class _OrdersTab extends StatefulWidget {
  const _OrdersTab();

  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          'Customer Orders',
          subtitle: 'Live orders management and status updates.',
        ),
        const SizedBox(height: 16),
        if (MockStore.orders.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text('No orders found.'),
            ),
          ),
        ...MockStore.orders.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textDark,
                      ),
                    ),
                    Text(
                      'KSh ${order.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.customerName} • ${order.productName} × ${order.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
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
                              order.destination,
                              style: const TextStyle(color: textMuted, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<OrderStatus>(
                  tooltip: 'Update status',
                  onSelected: (status) {
                    setState(() {
                      order.status = status;
                    });
                  },
                  itemBuilder: (_) => OrderStatus.values
                      .map(
                        (status) => PopupMenuItem<OrderStatus>(
                          value: status,
                          child: Text(orderStatusLabel(status)),
                        ),
                      )
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          orderStatusLabel(order.status),
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
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
// TAB 4: ADMIN PROFILE
// -----------------------------------------------------------------------------

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
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
                Icons.admin_panel_settings,
                size: 50,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Station Administrator',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'admin@aquafresh.com',
            style: TextStyle(fontSize: 14, color: textMuted),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.badge_outlined,
                  label: 'Admin ID',
                  value: 'ADM-001',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.phone_outlined,
                  label: 'Contact Phone',
                  value: '+254 700 123 456',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.store_outlined,
                  label: 'Assigned Station',
                  value: 'Main Refilling Station · Athi River',
                ),
                const Divider(height: 1),
                _buildProfileItem(
                  icon: Icons.security_outlined,
                  label: 'Access Level',
                  value: 'Full System Administration',
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
