import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/menu_data.dart';
import 'home_widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.searchController,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onCategoryChanged,
    required this.menuItems,
    required this.favoriteNames,
    required this.cartCount,
    required this.onOpenCart,
    required this.signedInEmail,
    required this.onSignIn,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenDetails,
  });

  final TextEditingController searchController;
  final List<String> categories;
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategoryChanged;
  final List<MenuItem> menuItems;
  final Set<String> favoriteNames;
  final int cartCount;
  final VoidCallback onOpenCart;
  final String? signedInEmail;
  final VoidCallback onSignIn;
  final ValueChanged<String> onToggleFavorite;
  final ValueChanged<MenuItem> onAddToCart;
  final ValueChanged<MenuItem> onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columnCount = width >= 1400
        ? 5
        : width >= 1000
        ? 4
        : width >= 600
        ? 3
        : 2;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Delivery to',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15,
                        color: AppColors.tomato,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Islamabad',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (signedInEmail == null)
              OutlinedButton.icon(
                onPressed: onSignIn,
                icon: const Icon(Icons.login, size: 17),
                label: const Text('Sign in'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.tomato,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(48, 42),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  signedInEmail!.split('@').first,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Stack(
              children: [
                InkWell(
                  onTap: onOpenCart,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.charcoal,
                    ),
                  ),
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.tomato,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => (context as Element).markNeedsBuild(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search food or category',
                    hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.paleOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune,
                  size: 18,
                  color: AppColors.tomato,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 210,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFEA8A45), Color(0xFFDB6D2B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -12,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=900&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: AppColors.paleOrange,
                        child: Center(
                          child: Icon(
                            Icons.restaurant,
                            color: AppColors.tomato,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Get 50% off today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hot deal of the burger',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 124,
                    child: ElevatedButton(
                      onPressed: () =>
                          onCategoryChanged(categories.indexOf('Burgers')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.tomato,
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Shop now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
            TextButton(
              onPressed: () => onCategoryChanged(0),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(48, 32),
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.tomato,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final label = categories[index];
              final selected = index == selectedCategoryIndex;
              return GestureDetector(
                onTap: () => onCategoryChanged(index),
                child: CategoryChip(label: label, selected: selected),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Popular dishes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal,
                ),
              ),
            ),
            TextButton(
              onPressed: () => onCategoryChanged(0),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(48, 32),
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.tomato,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: menuItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: width >= 1000
                ? 1.4
                : width >= 600
                ? 1.2
                : 1.05,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            final isFavorite = favoriteNames.contains(item.name);
            return MenuCard(
              item: item,
              isFavorite: isFavorite,
              onFavoriteToggle: () => onToggleFavorite(item.name),
              onAddToCart: () => onAddToCart(item),
              onTap: () => onOpenDetails(item),
            );
          },
        ),
        const SizedBox(height: 24),
        if (menuItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'No items match your search. Try another category or keyword.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ),
      ],
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({
    super.key,
    required this.favoriteItems,
    required this.onToggleFavorite,
    required this.onAddToCart,
    this.onOpenDetails,
  });

  final List<MenuItem> favoriteItems;
  final ValueChanged<String> onToggleFavorite;
  final ValueChanged<MenuItem> onAddToCart;
  final ValueChanged<MenuItem>? onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                'Your favorite items will appear here.',
                style: TextStyle(color: AppColors.muted, fontSize: 16),
              ),
            )
          : GridView.builder(
              itemCount: favoriteItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return MenuCard(
                  item: item,
                  isFavorite: true,
                  onFavoriteToggle: () => onToggleFavorite(item.name),
                  onAddToCart: () => onAddToCart(item),
                  onTap: () => onOpenDetails?.call(item),
                );
              },
            ),
    );
  }
}
