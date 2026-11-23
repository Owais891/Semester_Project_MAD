import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../orders/domain/customer_order.dart';
import 'home_helpers.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({
    super.key,
    required this.orders,
    required this.onOpenOrder,
    required this.onReorder,
    required this.onBrowseMenu,
  });

  final List<CustomerOrder> orders;
  final ValueChanged<CustomerOrder> onOpenOrder;
  final ValueChanged<CustomerOrder> onReorder;
  final VoidCallback onBrowseMenu;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 42,
              color: AppColors.orange,
            ),
            const SizedBox(height: 12),
            const Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your placed orders will show up here.',
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

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      itemCount: orders.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'Your orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
          );
        }
        final order = orders[index - 1];
        final shortId = order.id.substring(order.id.length - 6);
        final statusColor = order.status == 'Cancelled'
            ? AppColors.muted
            : const Color(0xFF287A4B);
        return Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order #$shortId',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                formatOrderDate(order.placedAt),
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                order.lines
                    .map((line) => '${line.quantity} x ${line.item.name}')
                    .join('  |  '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.charcoal, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatPkr(order.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.tomato,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onOpenOrder(order),
                    child: const Text('Details'),
                  ),
                  const SizedBox(width: 4),
                  OutlinedButton.icon(
                    onPressed: () => onReorder(order),
                    icon: const Icon(Icons.replay, size: 17),
                    label: const Text('Reorder'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
