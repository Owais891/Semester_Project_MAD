class MenuCategory {
  const MenuCategory({required this.name, required this.emoji});

  final String name;
  final String emoji;
}

class MenuItem {
  const MenuItem({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.badge,
    this.rating = 4.8,
  });

  final String name;
  final String category;
  final String description;
  final int price;
  final String imageUrl;
  final String? badge;
  final double rating;
}

const menuCategories = <MenuCategory>[
  MenuCategory(name: 'Pizza', emoji: '🍕'),
  MenuCategory(name: 'Fried Chicken', emoji: '🍗'),
  MenuCategory(name: 'Burgers', emoji: '🍔'),
  MenuCategory(name: 'Wraps & Rolls', emoji: '🌯'),
  MenuCategory(name: 'Wings', emoji: '🍗'),
  MenuCategory(name: 'Chicken Snacks', emoji: '🍿'),
  MenuCategory(name: 'Fries & Sides', emoji: '🍟'),
  MenuCategory(name: 'Pasta', emoji: '🍝'),
  MenuCategory(name: 'Sandwiches', emoji: '🥪'),
  MenuCategory(name: 'Platters', emoji: '🍱'),
  MenuCategory(name: 'Deals & Combos', emoji: '🔥'),
  MenuCategory(name: 'Drinks', emoji: '🥤'),
  MenuCategory(name: 'Desserts', emoji: '🍰'),
  MenuCategory(name: 'Kids Meals', emoji: '🧒'),
  MenuCategory(name: 'Add-ons', emoji: '🧀'),
];

// Food photography is served by Unsplash. Prices are whole Pakistani rupees.
// Replace the image URLs with restaurant-owned storage URLs when available.
String _photo(String id) =>
    'https://images.unsplash.com/$id?auto=format&fit=crop&w=800&q=82';

const menuItems = <MenuItem>[
  MenuItem(
    name: 'Garden Supreme Pizza',
    category: 'Pizza',
    description: 'Melty cheese, garden vegetables, and a golden crust.',
    price: 1299,
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=82',
    badge: 'BESTSELLER',
  ),
  MenuItem(
    name: 'Crispy Chicken',
    category: 'Fried Chicken',
    description: 'Juicy chicken with a crunchy, seasoned coating.',
    price: 899,
    imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'The Crust Burger',
    category: 'Burgers',
    description: 'Grilled patty, fresh lettuce, and house sauce.',
    price: 749,
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=82',
    badge: 'POPULAR',
  ),
  MenuItem(
    name: 'Smoky Fajita Roll',
    category: 'Wraps & Rolls',
    description: 'Tender fajita chicken wrapped with crisp greens.',
    price: 649,
    imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Firecracker Wings',
    category: 'Wings',
    description: 'Saucy wings with a little kick and a cool dip.',
    price: 799,
    imageUrl: 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Chicken Crunch Bites',
    category: 'Chicken Snacks',
    description: 'Bite-sized crispy chicken, made for sharing.',
    price: 499,
    imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Loaded Masala Fries',
    category: 'Fries & Sides',
    description: 'Golden fries tossed with a savory house seasoning.',
    price: 399,
    imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Creamy Tomato Pasta',
    category: 'Pasta',
    description: 'Comforting tomato cream sauce finished with herbs.',
    price: 899,
    imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Clubhouse Sandwich',
    category: 'Sandwiches',
    description: 'Toasted layers of chicken, cheese, and crunchy salad.',
    price: 699,
    imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Snack Attack Platter',
    category: 'Platters',
    description: 'Pizza, wings, mini sandwiches, chicken bites, fajita wraps, fries, and drinks.',
    price: 2999,
    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=1000&q=85',
    badge: 'SHARING DEAL',
    rating: 4.9,
  ),
  MenuItem(
    name: 'Family Feast Combo',
    category: 'Deals & Combos',
    description: 'A table-ready mix of Crust favorites for everyone.',
    price: 2499,
    imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=800&q=82',
    badge: 'SAVE 20%',
  ),
  MenuItem(
    name: 'Citrus Cooler',
    category: 'Drinks',
    description: 'Bright, chilled citrus with a refreshing sparkle.',
    price: 299,
    imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765edfd7?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Chocolate Sundae',
    category: 'Desserts',
    description: 'A cool, creamy treat with chocolate drizzle.',
    price: 449,
    imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Little Crunch Box',
    category: 'Kids Meals',
    description: 'Crispy chicken bites, fries, and a little drink.',
    price: 599,
    imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=800&q=82',
    badge: 'KIDS FAVORITE',
  ),
  MenuItem(
    name: 'Cheesy Garlic Dip',
    category: 'Add-ons',
    description: 'A creamy side dip for your crust, fries, or bites.',
    price: 149,
    imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'BBQ Chicken Pizza',
    category: 'Pizza',
    description: 'Smoky barbecue chicken, red onion, and melted cheese.',
    price: 1599,
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=82',
    badge: 'NEW',
  ),
  MenuItem(
    name: 'Pepperoni Feast Pizza',
    category: 'Pizza',
    description: 'A crisp golden base loaded with pepperoni and mozzarella.',
    price: 1799,
    imageUrl: 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Double Smash Burger',
    category: 'Burgers',
    description: 'Two seared patties, cheddar, pickles, and burger sauce.',
    price: 999,
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=82',
    badge: 'NEW',
  ),
  MenuItem(
    name: 'Classic Zinger Burger',
    category: 'Burgers',
    description: 'Crispy spiced chicken with lettuce and creamy mayo.',
    price: 799,
    imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433a?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Honey BBQ Wings',
    category: 'Wings',
    description: 'Sticky honey barbecue wings with a smoky finish.',
    price: 849,
    imageUrl: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?auto=format&fit=crop&w=800&q=82',
    badge: 'NEW',
  ),
  MenuItem(
    name: 'Peri Peri Chicken Wrap',
    category: 'Wraps & Rolls',
    description: 'Grilled peri peri chicken, slaw, and cooling sauce.',
    price: 699,
    imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Peri Peri Fries',
    category: 'Fries & Sides',
    description: 'Crispy fries dusted with our tangy peri peri spice.',
    price: 449,
    imageUrl: 'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Chicken Alfredo Pasta',
    category: 'Pasta',
    description: 'Creamy parmesan sauce with tender chicken and herbs.',
    price: 1099,
    imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?auto=format&fit=crop&w=800&q=82',
    badge: 'NEW',
  ),
  MenuItem(
    name: 'Garden Fresh Salad',
    category: 'Fries & Sides',
    description: 'Crunchy greens, tomatoes, cucumber, and house dressing.',
    price: 499,
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=82',
  ),
  MenuItem(
    name: 'Warm Chocolate Brownie',
    category: 'Desserts',
    description: 'Rich chocolate brownie served warm with a soft centre.',
    price: 499,
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=800&q=82',
  ),
];

List<String> menuItemGalleryImages(MenuItem item) {
  final relatedImages = menuItems
      .where(
        (menuItem) =>
            menuItem.category == item.category && menuItem.name != item.name,
      )
      .map((menuItem) => menuItem.imageUrl);
  final otherImages = menuItems
      .where((menuItem) => menuItem.name != item.name)
      .map((menuItem) => menuItem.imageUrl);
  return <String>{
    item.imageUrl,
    ...relatedImages,
    ...otherImages,
  }.take(10).toList();
}

// Shared image used for the wide platter promotion.
final platterPhotoUrl = _photo('photo-1555939594-58d7cb561ad1');
