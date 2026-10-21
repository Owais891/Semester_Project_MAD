part of 'home_page.dart';

class _CartTab extends StatelessWidget {
  const _CartTab({
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

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 42,
              color: AppColors.orange,
            ),
            const SizedBox(height: 12),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add something delicious to get started.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onBrowseMenu,
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Browse menu'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your cart',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
              Text(
                '${entries.length} items',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Clear cart',
                onPressed: onClear,
                icon: const Icon(Icons.delete_outline, color: AppColors.tomato),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final item = findItem(entry.key);
                if (item == null) return const SizedBox();

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 56,
                            height: 56,
                            color: AppColors.paleOrange,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.restaurant,
                              color: AppColors.tomato,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _formatPkr(item.price),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tomato,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: () => onRemove(entry.key),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ),
                          _QuantityButton(
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _CartSummaryLine(
                  label: 'Subtotal',
                  amount: cartTotal.toInt() - 150,
                ),
                const SizedBox(height: 6),
                const _CartSummaryLine(label: 'Delivery', amount: 150),
                const Divider(height: 18),
                _CartSummaryLine(
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
              icon: const Icon(Icons.payment_outlined),
              label: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSummaryLine extends StatelessWidget {
  const _CartSummaryLine({
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
          _formatPkr(amount),
          style: style.copyWith(color: emphasize ? AppColors.tomato : null),
        ),
      ],
    );
  }
}

