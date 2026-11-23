import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class _SavedAddress {
  const _SavedAddress({required this.label, required this.details});

  final String label;
  final String details;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.orderCount = 0, this.favoriteCount = 0});

  final int orderCount;
  final int favoriteCount;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Ayesha Khan';
  String _email = 'ayesha.khan@example.com';
  String _phone = '0300 1234567';
  String _paymentMethod = 'Cash on delivery';
  bool _signedIn = true;
  bool _orderUpdates = true;
  bool _offersAndNews = false;
  final List<_SavedAddress> _addresses = <_SavedAddress>[
    const _SavedAddress(
      label: 'Home',
      details: 'House 12, Street 4, F-7, Islamabad',
    ),
  ];

  String get _initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((part) => part.isEmpty ? '' : part[0]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined, color: AppColors.tomato),
                SizedBox(width: 8),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.orange, AppColors.tomato],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 33,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundColor: AppColors.paleOrange,
                          child: Text(
                            _signedIn ? _initials : 'G',
                            style: const TextStyle(
                              color: AppColors.tomato,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.tomato, width: 2),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          size: 12,
                          color: AppColors.tomato,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _signedIn ? _name : 'Guest',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _signedIn ? _email : 'Sign in to manage your account',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _signedIn ? _editProfile : _signIn,
                    icon: Icon(_signedIn ? Icons.edit_outlined : Icons.login),
                    label: Text(_signedIn ? 'Edit profile' : 'Sign in'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ProfileStat(
                    icon: Icons.receipt_long_outlined,
                    value: widget.orderCount.toString(),
                    label: 'Orders',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProfileStat(
                    icon: Icons.favorite_border,
                    value: widget.favoriteCount.toString(),
                    label: 'Favorites',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _ProfileSectionTitle(title: 'Account'),
            _ProfileGroup(
              children: [
                _ProfileAction(
                  icon: Icons.person_outline,
                  title: 'Personal information',
                  subtitle: 'Name, email and phone number',
                  onTap: _editProfile,
                ),
                _ProfileAction(
                  icon: Icons.location_on_outlined,
                  title: 'Saved addresses',
                  subtitle:
                      '${_addresses.length} delivery ${_addresses.length == 1 ? 'address' : 'addresses'}',
                  onTap: _manageAddresses,
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _ProfileSectionTitle(title: 'Preferences'),
            _ProfileGroup(
              children: [
                _ProfileAction(
                  icon: Icons.payments_outlined,
                  title: 'Payment preference',
                  subtitle: _paymentMethod,
                  onTap: _choosePaymentMethod,
                ),
                SwitchListTile.adaptive(
                  secondary: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.tomato,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  title: const Text('Order updates'),
                  subtitle: const Text('Receive updates about your orders'),
                  value: _orderUpdates,
                  activeTrackColor: AppColors.tomato,
                  onChanged: (value) => setState(() => _orderUpdates = value),
                ),
                SwitchListTile.adaptive(
                  secondary: const Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.tomato,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  title: const Text('Offers and news'),
                  subtitle: const Text('Occasional menu offers and updates'),
                  value: _offersAndNews,
                  activeTrackColor: AppColors.tomato,
                  onChanged: (value) => setState(() => _offersAndNews = value),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _ProfileSectionTitle(title: 'Support'),
            _ProfileGroup(
              children: [
                _ProfileAction(
                  icon: Icons.help_outline,
                  title: 'Help and support',
                  subtitle: 'Contact our customer care team',
                  onTap: () => _showInfo(
                    'Help and support',
                    'For help with an order, contact support@crustfood.example and include your order number.',
                  ),
                ),
                _ProfileAction(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  subtitle: 'How account information is handled',
                  onTap: () => _showInfo(
                    'Privacy',
                    'This demo stores profile settings only in app memory. No information is sent to a server.',
                  ),
                ),
                _ProfileAction(
                  icon: Icons.info_outline,
                  title: 'About Crust Food',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showInfo(
                    'About Crust Food',
                    'A local food-ordering app prototype. Online accounts, payments and order sync are not connected.',
                  ),
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _signedIn ? _confirmSignOut : _signIn,
              icon: Icon(_signedIn ? Icons.logout : Icons.login),
              label: Text(_signedIn ? 'Sign out' : 'Sign in'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.tomato,
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'CRUST FOOD  •  LOCAL DEMO',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final formKey = GlobalKey<FormState>();
    var name = _name;
    var email = _email;
    var phone = _phone;
    final result = await showDialog<(String, String, String)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Personal information'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  onChanged: (value) => name = value,
                  validator: (value) => value == null || value.trim().length < 2
                      ? 'Enter your name'
                      : null,
                ),
                TextFormField(
                  initialValue: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  onChanged: (value) => email = value,
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                TextFormField(
                  initialValue: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  onChanged: (value) => phone = value,
                  validator: (value) =>
                      value == null ||
                          value.replaceAll(RegExp(r'\D'), '').length < 10
                      ? 'Enter a valid phone number'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(dialogContext, (
                  name.trim(),
                  email.trim(),
                  phone.trim(),
                ));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _name = result.$1;
      _email = result.$2;
      _phone = result.$3;
    });
  }

  Future<void> _manageAddresses() async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.fromLTRB(
            18,
            18,
            18,
            18 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Saved addresses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                for (var index = 0; index < _addresses.length; index++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.paleOrange,
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.tomato,
                      ),
                    ),
                    title: Text(_addresses[index].label),
                    subtitle: Text(_addresses[index].details),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Address options',
                      onSelected: (choice) async {
                        if (choice == 'edit') {
                          await _editAddress(index: index);
                        } else {
                          setState(() => _addresses.removeAt(index));
                        }
                        setSheetState(() {});
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                if (_addresses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No saved addresses yet.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await _editAddress();
                      setSheetState(() {});
                    },
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Add address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editAddress({int? index}) async {
    final current = index == null ? null : _addresses[index];
    final formKey = GlobalKey<FormState>();
    var label = current?.label ?? 'Home';
    var details = current?.details ?? '';
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(current == null ? 'Add address' : 'Edit address'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: label,
                decoration: const InputDecoration(
                  labelText: 'Label (Home, Work...)',
                ),
                onChanged: (value) => label = value,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter an address label'
                    : null,
              ),
              TextFormField(
                initialValue: details,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Full delivery address',
                ),
                onChanged: (value) => details = value,
                validator: (value) => value == null || value.trim().length < 8
                    ? 'Enter a complete address'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(dialogContext, (label.trim(), details.trim()));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      final updated = _SavedAddress(label: result.$1, details: result.$2);
      if (index == null) {
        _addresses.add(updated);
      } else {
        _addresses[index] = updated;
      }
    });
  }

  Future<void> _choosePaymentMethod() async {
    var selected = _paymentMethod;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Payment preference'),
        content: DropdownButtonFormField<String>(
          initialValue: selected,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'Cash on delivery',
              child: Text('Cash on delivery'),
            ),
            DropdownMenuItem(
              value: 'Card on delivery',
              child: Text('Card on delivery'),
            ),
            DropdownMenuItem(
              value: 'Mobile wallet on delivery',
              child: Text('Mobile wallet on delivery'),
            ),
          ],
          onChanged: (value) => selected = value ?? selected,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, selected),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _paymentMethod = result);
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('This signs you out of the local demo profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => _signedIn = false);
  }

  void _signIn() => setState(() => _signedIn = true);

  Future<void> _showInfo(String title, String message) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.tomato, size: 17),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.charcoal,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.charcoal,
      ),
    ),
  );
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: AppColors.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(mainAxisSize: MainAxisSize.min, children: children),
  );
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity.compact,
        minVerticalPadding: 0,
        leading: Icon(icon, color: AppColors.tomato),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      ),
      if (showDivider) const Divider(height: 1, indent: 56),
    ],
  );
}
