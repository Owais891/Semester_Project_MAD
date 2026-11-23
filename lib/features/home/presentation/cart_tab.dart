import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/menu_data.dart';
import 'home_helpers.dart';
import 'home_widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.cartItems,
    required this.findItem,
    required this.onAdd,
    required this.onRemove,
    required this.cartTotal,
    this.onClear,
    this.onBrowseMenu,
    this.onCheckout,
  });

  final Map<String, int> cartItems;
  final MenuItem? Function(String name) findItem;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  final double cartTotal;
  final VoidCallback? onClear;
  final VoidCallback? onBrowseMenu;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final entries = cartItems.entries.toList();
    final itemCount = entries.fold<int>(
      0,
      (total, entry) => total + entry.value,
    );

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.paleOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppColors.tomato,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add something delicious to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onBrowseMenu,
              icon: const Icon(Icons.restaurant_menu_rounded),
              label: const Text('Explore the menu'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your cart',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your favorites, all in one place.',
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Clear cart',
                onPressed: onClear,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.paleOrange,
                  foregroundColor: AppColors.tomato,
                  minimumSize: const Size(42, 42),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final item = findItem(entry.key);
                if (item == null) return const SizedBox();

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.charcoal.withValues(alpha: 0.035),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          item.imageUrl,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 76,
                            height: 76,
                            color: AppColors.paleOrange,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.restaurant,
                              color: AppColors.tomato,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatPkr(item.price),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tomato,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          QuantityButton(
                            icon: Icons.remove,
                            onTap: () => onRemove(entry.key),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ),
                          QuantityButton(
                            icon: Icons.add,
                            onTap: () => onAdd(entry.key),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 14),
                CartSummaryLine(
                  label: 'Subtotal',
                  amount: cartTotal.toInt() - 150,
                ),
                const SizedBox(height: 6),
                const CartSummaryLine(label: 'Delivery', amount: 150),
                const Divider(height: 18),
                CartSummaryLine(
                  label: 'Total',
                  amount: cartTotal.toInt(),
                  emphasize: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class CartSummaryLine extends StatelessWidget {
  const CartSummaryLine({
    super.key,
    required this.label,
    required this.amount,
    this.emphasize = false,
  });

  final String label;
  final int amount;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: emphasize ? AppColors.charcoal : AppColors.muted,
      fontSize: emphasize ? 16 : 13,
      fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          formatPkr(amount),
          style: style.copyWith(color: emphasize ? AppColors.tomato : null),
        ),
      ],
    );
  }
}
