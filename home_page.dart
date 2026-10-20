import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../orders/domain/customer_order.dart';
import '../data/menu_data.dart';
import 'cart_tab.dart';
import 'home_helpers.dart';
import 'home_menu_tab.dart';
import 'orders_tab.dart';
import 'home_widgets.dart';
import 'profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteNames = <String>{};
  final Map<String, int> _cartItems = <String, int>{};
  final List<CustomerOrder> _orders = <CustomerOrder>[];
  int _selectedCategoryIndex = 0;
  int _selectedNavIndex = 0;
  String? _signedInEmail;
  static const int _deliveryFee = 150;

  List<String> get categories => <String>[
    'All',
    ...menuCategories.map((category) => category.name),
  ];

  List<MenuItem> get filteredMenuItems {
    final query = _searchController.text.trim().toLowerCase();
    final selectedCategory = categories[_selectedCategoryIndex];

    return menuItems.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;
      final text = '${item.name} ${item.category} ${item.description}'
          .toLowerCase();
      final matchesQuery = query.isEmpty || text.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<MenuItem> get favoriteMenuItems {
    return menuItems
        .where((item) => _favoriteNames.contains(item.name))
        .toList();
  }

  int get totalCartCount =>
      _cartItems.values.fold<int>(0, (total, quantity) => total + quantity);

  int get cartSubtotal => _cartItems.entries.fold<int>(
    0,
    (sum, entry) => sum + (findMenuItem(entry.key)?.price ?? 0) * entry.value,
  );

  double get cartTotal =>
      (cartSubtotal + (_cartItems.isEmpty ? 0 : _deliveryFee)).toDouble();

  MenuItem? findMenuItem(String name) {
    for (final item in menuItems) {
      if (item.name == name) {
        return item;
      }
    }
    return null;
  }

  void addToCart(MenuItem item, {int quantity = 1}) {
    setState(() {
      final current = _cartItems[item.name] ?? 0;
      _cartItems[item.name] = current + quantity;
    });
  }

  void updateCartQuantity(String itemName, int delta) {
    setState(() {
      final current = _cartItems[itemName] ?? 0;
      final next = current + delta;
      if (next <= 0) {
        _cartItems.remove(itemName);
      } else {
        _cartItems[itemName] = next;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCheckout(BuildContext context) async {
    if (_cartItems.isEmpty) return;
    final formKey = GlobalKey<FormState>();
    var customerName = '';
    var phone = '';
    var address = '';
    var paymentMethod = 'Cash on delivery';
    final details = await showDialog<(String, String, String, String)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Delivery details'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) => customerName = value,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          value == null || value.trim().length < 2
                          ? 'Enter your name'
                          : null,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => phone = value,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) =>
                          value == null ||
                              value
                                      .trim()
                                      .replaceAll(RegExp(r'\D'), '')
                                      .length <
                                  10
                          ? 'Enter a valid phone number'
                          : null,
                    ),
                    TextFormField(
                      maxLines: 2,
                      onChanged: (value) => address = value,
                      decoration: const InputDecoration(
                        labelText: 'Delivery address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.trim().length < 8
                          ? 'Enter a full delivery address'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: paymentMethod,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Payment method',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Cash on delivery',
                          child: Text('Cash on delivery'),
                        ),
                        DropdownMenuItem(
                          value: 'Card on delivery',
                          child: Text('Card on delivery'),
                        ),
                      ],
                      onChanged: (value) => setDialogState(
                        () => paymentMethod = value ?? paymentMethod,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CartSummaryLine(label: 'Subtotal', amount: cartSubtotal),
                    const SizedBox(height: 6),
                    const CartSummaryLine(
                      label: 'Delivery',
                      amount: _deliveryFee,
                    ),
                    const Divider(height: 18),
                    CartSummaryLine(
                      label: 'Total',
                      amount: cartTotal.toInt(),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Back'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.pop(dialogContext, (
                    customerName.trim(),
                    phone.trim(),
                    address.trim(),
                    paymentMethod,
                  ));
                }
              },
              child: const Text('Place order'),
            ),
          ],
        ),
      ),
    );
    if (details == null || !context.mounted) return;

    final lines = <OrderLine>[];
    for (final entry in _cartItems.entries) {
      final item = findMenuItem(entry.key);
      if (item != null) {
        lines.add(OrderLine(item: item, quantity: entry.value));
      }
    }
    final order = CustomerOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      placedAt: DateTime.now(),
      lines: lines,
      customerName: details.$1,
      phone: details.$2,
      address: details.$3,
      paymentMethod: details.$4,
      subtotal: cartSubtotal,
      deliveryFee: _deliveryFee,
      status: 'Confirmed',
    );
    setState(() {
      _orders.insert(0, order);
      _cartItems.clear();
      _selectedNavIndex = 3;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order #${order.id.substring(order.id.length - 6)} confirmed.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            HomeTab(
              searchController: _searchController,
              categories: categories,
              selectedCategoryIndex: _selectedCategoryIndex,
              onCategoryChanged: (index) =>
                  setState(() => _selectedCategoryIndex = index),
              menuItems: filteredMenuItems,
              favoriteNames: _favoriteNames,
              cartCount: totalCartCount,
              onOpenCart: () => setState(() => _selectedNavIndex = 2),
              signedInEmail: _signedInEmail,
              onSignIn: _openLogin,
              onToggleFavorite: (name) => setState(() {
                if (_favoriteNames.contains(name)) {
                  _favoriteNames.remove(name);
                } else {
                  _favoriteNames.add(name);
                }
              }),
              onAddToCart: addToCart,
              onOpenDetails: (item) => _showItemSheet(context, item),
            ),
            FavoritesTab(
              favoriteItems: favoriteMenuItems,
              onToggleFavorite: (name) =>
                  setState(() => _favoriteNames.remove(name)),
              onAddToCart: addToCart,
              onOpenDetails: (item) => _showItemSheet(context, item),
            ),
            CartTab(
              cartItems: _cartItems,
              findItem: findMenuItem,
              onAdd: (name) => updateCartQuantity(name, 1),
              onRemove: (name) => updateCartQuantity(name, -1),
              cartTotal: cartTotal,
              onClear: () => setState(_cartItems.clear),
              onBrowseMenu: () => setState(() => _selectedNavIndex = 0),
              onCheckout: () => _showCheckout(context),
            ),
            OrdersTab(
              orders: _orders,
              onOpenOrder: (order) => _showOrderDetails(context, order),
              onReorder: _reorderOrder,
              onBrowseMenu: () => setState(() => _selectedNavIndex = 0),
            ),
            ProfileTab(
              orderCount: _orders.length,
              favoriteCount: _favoriteNames.length,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onChanged: (index) => setState(() => _selectedNavIndex = index),
      ),
    );
  }

  Future<void> _openLogin() async {
    final email = await context.push<String>(AppRoutes.login);
    if (!mounted || email == null) return;
    setState(() => _signedInEmail = email);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Signed in as $email')));
  }

  void _showOrderDetails(BuildContext context, CustomerOrder order) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Order #${order.id.substring(order.id.length - 6)}'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${order.status}  |  ${formatOrderDate(order.placedAt)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const Divider(height: 22),
                for (final line in order.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('${line.quantity} x ${line.item.name}'),
                        ),
                        Text(
                          formatPkr(line.total),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 20),
                CartSummaryLine(label: 'Subtotal', amount: order.subtotal),
                const SizedBox(height: 5),
                CartSummaryLine(label: 'Delivery', amount: order.deliveryFee),
                const Divider(height: 18),
                CartSummaryLine(
                  label: 'Total paid on delivery',
                  amount: order.total,
                  emphasize: true,
                ),
                const SizedBox(height: 12),
                Text(
                  'Deliver to ${order.customerName}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  order.address,
                  style: const TextStyle(color: AppColors.muted),
                ),
                Text(
                  order.phone,
                  style: const TextStyle(color: AppColors.muted),
                ),
                Text(
                  order.paymentMethod,
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (order.status == 'Confirmed')
            TextButton(
              onPressed: () {
                setState(() {
                  final index = _orders.indexWhere(
                    (entry) => entry.id == order.id,
                  );
                  if (index >= 0) {
                    _orders[index] = _orders[index].withStatus('Cancelled');
                  }
                });
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel order',
                style: TextStyle(color: AppColors.tomato),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _reorderOrder(CustomerOrder order) {
    setState(() {
      for (final line in order.lines) {
        _cartItems.update(
          line.item.name,
          (quantity) => quantity + line.quantity,
          ifAbsent: () => line.quantity,
        );
      }
      _selectedNavIndex = 2;
    });
  }

  void _showItemSheet(BuildContext context, MenuItem item) {
    var isFavorite = _favoriteNames.contains(item.name);
    var quantity = 1;
    final galleryImages = menuItemGalleryImages(item);
    var imageIndex = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7DFD8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Column(
                      children: [
                        SizedBox(
                          height: 210,
                          child: PageView.builder(
                            itemCount: galleryImages.length,
                            onPageChanged: (index) =>
                                setSheetState(() => imageIndex = index),
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                galleryImages[index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: AppColors.paleOrange,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.restaurant,
                                    color: AppColors.tomato,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            galleryImages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: imageIndex == index ? 12 : 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: imageIndex == index
                                    ? AppColors.tomato
                                    : AppColors.border,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.charcoal,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isFavorite) {
                                _favoriteNames.remove(item.name);
                              } else {
                                _favoriteNames.add(item.name);
                              }
                            });
                            setSheetState(() => isFavorite = !isFavorite);
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? AppColors.tomato
                                : AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFB000),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatPkr(item.price),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setSheetState(
                                  () => quantity = quantity > 1
                                      ? quantity - 1
                                      : 1,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.remove, size: 18),
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.charcoal,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setSheetState(() => quantity++),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.add, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          addToCart(item, quantity: quantity);
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(sheetContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${item.name} added to cart x$quantity.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Add to cart'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
