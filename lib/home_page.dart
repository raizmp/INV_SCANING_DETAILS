import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'scaning_details_page.dart';
import 'main.dart'; // Import main.dart for LoginPage

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> shops = [];

  @override
  void initState() {
    super.initState();
    _fetchShops();
  }

  // Fetch shop details from backend
  Future<void> _fetchShops() async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/inv_scaning_get_shop.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        setState(() {
          shops = List<Map<String, dynamic>>.from(responseData['shops']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  // Fetch shop name based on shop code
  Future<void> _fetchShopName(String shopCode, TextEditingController shopNameController) async {
    final String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/get_shop_name.php?shop_code=$shopCode';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        shopNameController.text = responseData['shop_name'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch shop name')),
      );
    }
  }

  // Send shop details to PHP backend
  Future<void> _addShopDetails({
    required String shopCode,
    required String shopName,
    required String date,
    required String remark,
  }) async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/inv_scaning_form_shop.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'shop_code': shopCode,
          'shop_name': shopName,
          'date': date,
          'remark': remark,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        _fetchShops();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  // Logout with confirmation dialog
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false, // Remove all previous routes
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Show dialog to add shop details
  void _showAddShopDialog() {
    final shopCodeController = TextEditingController();
    final shopNameController = TextEditingController();
    final remarkController = TextEditingController();
    DateTime? selectedDate;
    bool isButtonPressed = false;
    Timer? _debounce;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Shop Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: shopCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Code',
                        prefixIcon: Icon(Icons.store),
                      ),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          if (value.isNotEmpty) {
                            _fetchShopName(value, shopNameController);
                          } else {
                            shopNameController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: shopNameController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Name',
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: Theme.of(context).colorScheme.copyWith(
                                      primary: Theme.of(context).colorScheme.primary,
                                      onPrimary: Colors.white,
                                    ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          selectedDate == null
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: remarkController,
                      decoration: const InputDecoration(
                        labelText: 'Remark (optional)',
                        prefixIcon: Icon(Icons.comment),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                GestureDetector(
                  onTapDown: (_) {
                    setDialogState(() {
                      isButtonPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setDialogState(() {
                      isButtonPressed = false;
                    });
                    if (shopCodeController.text.isNotEmpty &&
                        shopNameController.text.isNotEmpty &&
                        selectedDate != null) {
                      _addShopDetails(
                        shopCode: shopCodeController.text,
                        shopName: shopNameController.text, // Use TextField value
                        date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                        remark: remarkController.text,
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                        ),
                      );
                    }
                  },
                  onTapCancel: () {
                    setDialogState(() {
                      isButtonPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    transform: Matrix4.identity()
                      ..scale(isButtonPressed ? 0.95 : 1.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: null, // Handled by GestureDetector
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: const Text('Add'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      _debounce?.cancel(); // Clean up debounce timer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Shops',
            onPressed: _fetchShops,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Shop Details',
            onPressed: _showAddShopDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: shops.isEmpty
          ? const Center(child: Text('No shops available'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.store,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      shop['shop_name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Code: ${shop['shop_code']}\n'
                      'Date: ${shop['date']}\n'
                      'Remark: ${shop['remark'] ?? 'No remark'}',
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopScanningDetailsPage(
                            shop: shop,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}