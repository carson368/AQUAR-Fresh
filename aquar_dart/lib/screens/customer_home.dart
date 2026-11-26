import 'package:flutter/material.dart';

import '../configs/colors.dart';
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
        title: const Row(
          children: [
            Icon(Icons.water_drop, color: primaryColor, size: 26),
            SizedBox(width: 8),
            Text(
              'AQUAR Fresh',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
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
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: tab,
        children: const [
          _ShopTab(),
          _OrdersTab(),
          ProfileScreen(),
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
// WATER / SHOP TAB
// -----------------------------------------------------------------------------

class _ShopTab extends StatefulWidget {
  const _ShopTab();

  @override
  State<_ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<_ShopTab> {
  int selectedCategory = 0; // 0: All, 1: Refills, 2: Bottled

  @override
  Widget build(BuildContext context) {
    final filteredProducts = MockStore.products.where((p) {
      if (selectedCategory == 1) return p.name.contains('Refill');
      if (selectedCategory == 2) return p.name.contains('Bottled');
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryDark, primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: Colors.amberAccent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Fast 30-min doorstep delivery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pure, Clean Water\nDelivered Fresh.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Refill your 10L / 20L containers or order sealed mineral bottles.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('All Products', 0),
              const SizedBox(width: 8),
              _buildCategoryChip('Refill Water', 1),
              const SizedBox(width: 8),
              _buildCategoryChip('Bottled Water', 2),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const SectionTitle(
          'Available products',
          subtitle: 'Choose your preferred size and quantity',
        ),

        const SizedBox(height: 14),

        // 2-Column Product Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.69,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final isRefill = product.name.contains('Refill');

            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(product: product),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image & Badge
                    Expanded(
                      flex: 5,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _ProductImage(image: product.image),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isRefill ? primaryColor : successColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isRefill ? 'REFILL' : 'SEALED',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product Details
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${product.name} · ${product.size}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                    color: textMuted,
                                    fontSize: 11,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'KSh ${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, int index) {
    final isSelected = selectedCategory == index;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => selectedCategory = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? image;

  const _ProductImage({this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Container(
        color: secondaryColor,
        child: const Icon(Icons.water_drop_outlined, color: primaryColor, size: 36),
      );
    }

    final isNetwork =
        image!.startsWith('http://') || image!.startsWith('https://');

    return Image(
      image: isNetwork
          ? NetworkImage(image!)
          : AssetImage(image!) as ImageProvider,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: secondaryColor,
        child: const Icon(Icons.water_drop_outlined, color: primaryColor, size: 36),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CHECKOUT SCREEN (ITEMIZED SUMMARY & M-PESA PROMPT)
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
  final TextEditingController phoneController =
      TextEditingController(text: '+254 712 345 678');
  String payment = 'M-Pesa';

  @override
  void dispose() {
    destination.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.product.price * qty;
    const deliveryFee = 0.0; // Free delivery promo
    final total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product Card Preview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: _ProductImage(image: widget.product.image),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.product.name} · ${widget.product.size}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.description,
                          style: const TextStyle(color: textMuted, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'KSh ${widget.product.price.toStringAsFixed(0)} each',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quantity Selector Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'Select number of units',
                        style: TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: qty > 1 ? () => setState(() => qty--) : null,
                    icon: const Icon(Icons.remove, size: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '$qty',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () => setState(() => qty++),
                    icon: const Icon(Icons.add, size: 18),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Delivery Location
          TextField(
            controller: destination,
            decoration: const InputDecoration(
              labelText: 'Delivery location',
              hintText: 'e.g. Main Campus Hostel, Room 12',
              prefixIcon: Icon(Icons.location_on_outlined, color: primaryColor),
            ),
          ),

          const SizedBox(height: 20),

          // Payment Method Selector
          const SectionTitle(
            'Payment Method',
            subtitle: 'Choose how you want to pay',
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildPaymentTile(
                  title: 'M-Pesa',
                  subtitle: 'Instant STK push',
                  icon: Icons.phone_android,
                  value: 'M-Pesa',
                  badgeColor: successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentTile(
                  title: 'Cash',
                  subtitle: 'Pay on delivery',
                  icon: Icons.payments_outlined,
                  value: 'Cash',
                  badgeColor: warningColor,
                ),
              ),
            ],
          ),

          // If M-Pesa is selected, prompt phone number
          if (payment == 'M-Pesa') ...[
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'M-Pesa Phone Number',
                hintText: '+254 7XX XXX XXX',
                prefixIcon: const Icon(Icons.phone, color: successColor),
                helperText: 'You will receive an STK payment prompt on this line.',
                helperStyle: TextStyle(color: Colors.green.shade700, fontSize: 11),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Itemized Order Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.product.name} × $qty',
                        style: const TextStyle(color: textMuted),
                      ),
                      Text(
                        'KSh ${subtotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Delivery Fee',
                        style: TextStyle(color: textMuted),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'FREE PROMO',
                              style: TextStyle(
                                color: successColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'KSh 0',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      Text(
                        'KSh ${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
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

          const SizedBox(height: 24),

          ElevatedButton.icon(
            icon: const Icon(Icons.lock_outline, size: 18),
            onPressed: () {
              if (destination.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a delivery location.'),
                  ),
                );
                return;
              }

              if (payment == 'M-Pesa' && phoneController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your M-Pesa phone number.'),
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
                    title: const Row(
                      children: [
                        Icon(Icons.check_circle, color: successColor),
                        SizedBox(width: 8),
                        Text('Order Placed!'),
                      ],
                    ),
                    content: Text(
                      payment == 'M-Pesa'
                          ? 'Your order was created. An STK push prompt has been sent to ${phoneController.text.trim()}. Please enter your M-Pesa PIN on your phone.'
                          : 'Your order was created successfully! Please have KSh ${total.toStringAsFixed(0)} ready in cash when your delivery rider arrives.',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                        },
                        child: const Text('View My Orders'),
                      ),
                    ],
                  );
                },
              );
            },
            label: Text('Place Order · KSh ${total.toStringAsFixed(0)}'),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required Color badgeColor,
  }) {
    final isSelected = payment == value;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => payment = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: isSelected ? primaryColor : textDark),
                if (isSelected)
                  const Icon(Icons.check_circle, color: primaryColor, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? primaryColor : textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: textMuted, fontSize: 11),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          'My orders',
          subtitle: 'Track your current and previous water orders.',
        ),
        const SizedBox(height: 14),
        if (customerOrders.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: textMuted),
                  SizedBox(height: 12),
                  Text(
                    'No orders yet.',
                    style: TextStyle(color: textMuted),
                  ),
                ],
              ),
            ),
          ),
        ...customerOrders.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            orderStatusLabel(order.status),
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${order.productName} × ${order.quantity}',
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Profile avatar
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 46,
                  backgroundColor: secondaryColor,
                  child: Icon(Icons.person, size: 50, color: primaryColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Carson Ndanya',
            style: TextStyle(
              color: textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'carson@aquafresh.com',
            style: TextStyle(fontSize: 14, color: textMuted),
          ),

          const SizedBox(height: 24),

          // Profile Info Card
          Card(
            child: Column(
              children: [
                _buildProfileTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: '+254 712 345 678',
                ),
                const Divider(height: 1),
                _buildProfileTile(
                  icon: Icons.location_on_outlined,
                  label: 'Default Address',
                  value: 'Daystar University, Athi River',
                ),
                const Divider(height: 1),
                _buildProfileTile(
                  icon: Icons.calendar_month_outlined,
                  label: 'Member Since',
                  value: 'March 2026',
                ),
                const Divider(height: 1),
                _buildProfileTile(
                  icon: Icons.badge_outlined,
                  label: 'Account Role',
                  value: 'Customer',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileTile({
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
