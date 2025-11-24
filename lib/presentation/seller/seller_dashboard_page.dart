// lib/presentation/seller/seller_dashboard_page.dart
import 'package:flutter/material.dart';

import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'controller/seller_dashboard_controller.dart';
import 'models/seller_dashboard_model.dart';

// widgets
import 'widgets/seller_header_card.dart';
import 'widgets/seller_stat_card.dart';
import 'widgets/seller_tab_bar.dart';
import 'widgets/seller_home_tab.dart';
import 'widgets/seller_products_tab.dart';

class SellerDashboardPage extends StatefulWidget {
  const SellerDashboardPage({super.key});

  @override
  State<SellerDashboardPage> createState() => _SellerDashboardPageState();
}

class _SellerDashboardPageState extends State<SellerDashboardPage> {
  final SellerDashboardController _controller = SellerDashboardController();

  bool _isLoading = true;
  SellerDashboardData? _data;
  int _selectedTab = 0;

  final TextEditingController _editStoreNameController =
      TextEditingController();
  final TextEditingController _editAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  @override
  void dispose() {
    _editStoreNameController.dispose();
    _editAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);
    try {
      final data = await _controller.fetchDashboardData();
      _editStoreNameController.text = data.storeName;
      _editAddressController.text = data.storeAddress;
      setState(() {
        _data = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load dashboard: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openEditStoreInfo() async {
    if (_data == null) return;
    _editStoreNameController.text = _data!.storeName;
    _editAddressController.text = _data!.storeAddress;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Store Info',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _editStoreNameController,
                decoration: InputDecoration(
                  labelText: 'Store Name',
                  hintText: _editStoreNameController.text.isEmpty
                      ? 'Enter your store name'
                      : null, // <-- hint kalau kosong
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _editAddressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: _editAddressController.text.isEmpty
                      ? 'Enter store address'
                      : null, // <-- hint kalau kosong
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final newName = _editStoreNameController.text.trim();
                    final newAddress = _editAddressController.text.trim();
                    await _controller.updateStoreInfo(
                      storeName: newName,
                      storeAddress: newAddress,
                    );
                    if (mounted && _data != null) {
                      setState(() {
                        _data = _data!.copyWith(
                          storeName: newName,
                          storeAddress: newAddress,
                        );
                      });
                    }
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kScaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Seller Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.blueAccent,
            ),
            onPressed: _openEditStoreInfo,
          ),
        ],
      ),
      body: _isLoading || _data == null
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, c) {
                final s = calcScale(c);
                return Scale(
                  s: s,
                  child: Builder(
                    builder: (ctx) => SingleChildScrollView(
                      padding: EdgeInsets.all(dp(ctx, 24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SellerHeaderCard(data: _data!),
                          SizedBox(height: dp(ctx, 16)),
                          Row(
                            children: [
                              Expanded(
                                child: SellerStatCard(
                                  title: 'Products',
                                  value: _data!.productCount.toString(),
                                ),
                              ),
                              SizedBox(width: dp(ctx, 12)),
                              Expanded(
                                child: SellerStatCard(
                                  title: 'Address',
                                  value: _data!.storeAddress.isEmpty
                                      ? '-'
                                      : _data!.storeAddress,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: dp(ctx, 24)),
                          SellerTabBar(
                            selectedIndex: _selectedTab,
                            onTabSelected: _onTabSelected,
                          ),
                          const Divider(thickness: 1),
                          SizedBox(height: dp(ctx, 16)),
                          if (_selectedTab == 0)
                            SellerHomeTab(data: _data!)
                          else
                            SellerProductsTab(data: _data!),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
