import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_scanning_detail_page.dart';
import 'add_scanning_detail_page.dart';
import 'edit_scanning_detail_page.dart';

class ShopScanningDetailsPage extends StatefulWidget {
  final Map<String, dynamic> shop;

  const ShopScanningDetailsPage({super.key, required this.shop});

  @override
  State<ShopScanningDetailsPage> createState() => _ShopScanningDetailsPageState();
}

class _ShopScanningDetailsPageState extends State<ShopScanningDetailsPage> with RouteAware {
  List<Map<String, dynamic>> scanningDetails = [];
  List<Map<String, dynamic>> filteredScanningDetails = [];
  String? selectedSection;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  static const List<String> sections = [
    'BAGS & TROLLEY -BACK PACK',
    'BAGS & TROLLEY -HAND BAG',
    'BAGS & TROLLEY -TROLLEY BAG',
    'BAKERY PRODUCTS-CAKES & SNACKS',
    'BAKERY PRODUCTS-PASTRIES',
    'BAKERY PRODUCTS-RAEDY TO EAT',
    'BEVERAGES-COOL DRINKS',
    'BEVERAGES-ENERGY DRINKS',
    'BEVERAGES-FRESH JUICES',
    'BEVERAGES-MINERAL WATER',
    'BEVERAGES-SOFT DRINKS',
    'BISCUITS & COOKIES-BUTTER COOKIES',
    'BISCUITS & COOKIES-CRACKER',
    'BISCUITS & COOKIES-CREAM BISCUITS',
    'BISCUITS & COOKIES-DIGESTIVE BISCUITS',
    'BISCUITS & COOKIES-RUSK',
    'CHILLED & DAIRY-BATTER & RAEDY TO COOK',
    'CHILLED & DAIRY-CHEESE & LABENEH',
    'CHILLED & DAIRY-DAIRY PRODUCTS',
    'CHILLED & DAIRY-EGGS',
    'CONFICTIONARY-CHIPS',
    'CONFICTIONARY-CHOCOLATES',
    'COSMETICS-BABY CARE',
    'COSMETICS-BATH & BODY CARE',
    'COSMETICS-HAIR CARE',
    'COSMETICS-HEALTH & BEAUTY',
    'COSMETICS-HEALTH CARE EQUIPMENTS',
    'COSMETICS-ORAL CARE',
    'COSMETICS-PERFUMES & DEO.',
    'DETERGENTS-CLEANING ACCESSORIES',
    'DETERGENTS-CLEANING AGENTS',
    'DETERGENTS-DISH WASH',
    'DETERGENTS-HOME FRAGRANCE',
    'DETERGENTS-INSECT KILLER',
    'DETERGENTS-LAUNDRY',
    'DETERGENTS-SHOE POLISH & BRUSH',
    'DETERGENTS-SPRAY CLEANERS',
    'DETERGENTS-WC FRESHNER',
    'ELECTRONICS-AUDIO & MUSIC',
    'ELECTRONICS-CAMERA, LENS AND ACCESSORIES',
    'ELECTRONICS-GAMING & ACCESSORIES',
    'ELECTRONICS-GROOMING TOOLS',
    'ELECTRONICS-HOME APPLIANCES',
    'ELECTRONICS-TELEPHONE & ACCESSORIES',
    'ELECTRONICS-TORCH & STANDBY LIGHT',
    'ELECTRONICS-TV & ACCESSORIES',
    'FANCY-HAIR ACCESSORIES',
    'FANCY-MAKE UP KIT',
    'FANCY-ORNAMENTS',
    'FASHION ACCESSORIES-BELT',
    'FASHION ACCESSORIES-CAP & HAT',
    'FASHION ACCESSORIES-SUN GLASS',
    'FASHION ACCESSORIES-WALLET',
    'FISHERY-DRY FISH',
    'FISHERY-FREOZEN FISH',
    'FOOD PRODUCTS-AFRICAN FOOD',
    'FOOD PRODUCTS-BABY FOOD',
    'FOOD PRODUCTS-BAKING AND DESSERT INGREDIENT',
    'FOOD PRODUCTS-CANNED FOOD',
    'FOOD PRODUCTS-CONFLAKES & CEREALS',
    'FOOD PRODUCTS-INSTANT DRINK',
    'FOOD PRODUCTS-JAMS & SPREADS',
    'FOOD PRODUCTS-MILK PRODUCTS',
    'FOOD PRODUCTS-MIXTURE & SNACKS',
    'FOOD PRODUCTS-NOODLES & SOUP',
    'FOOD PRODUCTS-OIL & GHEE',
    'FOOD PRODUCTS-ORGANIC FOOD',
    'FOOD PRODUCTS-PASTA',
    'FOOD PRODUCTS-PRESERVED FOOD',
    'FOOD PRODUCTS-SAUCE & DRESSING',
    'FOOD PRODUCTS-SUGAR,SUGAR SUBSTITUTE AND SARBATH',
    'FOOD PRODUCTS-TAE & COFFEE',
    'FOOTWEAR-KIDS SHOE',
    'FOOTWEAR-LADIES SANDAL',
    'FOOTWEAR-LADIES SHOE',
    'FOOTWEAR-MENS SANDAL',
    'FOOTWEAR-MENS SHOE',
    'FOOTWEAR-SAFETY SHOE',
    'FOOTWEAR-SLIPPER',
    'FROZEN FOODS',
    'FROZEN FOODS-FROZEN VEGETABLES',
    'FROZEN FOODS-ICE CREAM',
    'FROZEN FOODS-READY TO COOK',
    'GARMENTS-BED SHEET & BLANKETS',
    'GARMENTS-FESTIVAL DRESS',
    'GARMENTS-LADIES TOP',
    'GARMENTS-LOUNGE WEAR KIDS',
    'GARMENTS-LOUNGE WEAR MEN',
    'GARMENTS-LOUNGE WEAR WOMEN',
    'GARMENTS-LUNGI',
    'GARMENTS-READYMADES KIDS',
    'GARMENTS-READYMADES MEN',
    'GARMENTS-READYMADES WOMENS',
    'GARMENTS-SHIRTING & SUITING',
    'GARMENTS-TRADITIONAL WEAR',
    'GARMENTS-UNDERGARMENT KIDS',
    'GARMENTS-UNDERGARMENT MEN',
    'GARMENTS-UNDERGARMENT WOMEN',
    'GARMENTS-WINTER ITEMS',
    'GIFT-FLOWERS',
    'GIFT-STAND AND HOLDERS',
    'GIFT-STATUE AND FRAMES',
    'HEALTH CARE-HEALTH SUPPLIMENTS',
    'HEALTH CARE-PAIN RELIEVERS',
    'HOUSE HOLD',
    'HOUSE HOLD-CROCKERY',
    'HOUSE HOLD-DISPOSSABLES & TISSUES',
    'HOUSE HOLD-HARDWARE TOOLS & ACCESSORIES',
    'HOUSE HOLD-HOME ACCESSORIES',
    'HOUSE HOLD-HOME APPLIANCES',
    'HOUSE HOLD-HOME DECORE',
    'HOUSE HOLD-KITCHEN TOOLS',
    'HOUSE HOLD-PLASTIC PRODUCTS',
    'MASALA-CURRY POWDER & SPICES',
    'MASALA-ESSENSES & COLORS',
    'MASALA-FLOURS',
    'MASALA-OTHER GRAINS',
    'MASALA-PLUSES',
    'MASALA-READY TO COOK',
    'MASALA-RICE BAG',
    'MASALA-SALT',
    'MOBILE PHONE & ACC.',
    'PERFUME & DEODORANT',
    'PET SUPPLIES-PET ACCESSORIES',
    'PET SUPPLIES-PET FOOD',
    'SMOKING ACCESSORIES',
    'STATIONARY-TRAVEL ACCESSORIES',
    'STATIONEY-BOOKS & PAPER',
    'STATIONEY-CARDIO & EXERCISE ACCESSORIES',
    'STATIONEY-CYCLE & SCOOTER',
    'STATIONEY-HUNTING & FISHING',
    'STATIONEY-MAGAZINE & NEWS PAPER',
    'STATIONEY-OFFICE & EDUCATIONAL SUPPLIES',
    'STATIONEY-SPORTS TOOLS',
    'STATIONEY-TAILORING',
    'TOYS & DOLLS-DOLLS',
    'TOYS & DOLLS-TOYS',
    'WATCH-GENTS WATCH',
    'WATCH-KIDS WATCH',
    'WATCH-LADIES WATCH',
  ];

  @override
  void initState() {
    super.initState();
    _fetchScanningDetails();
    filteredScanningDetails = scanningDetails;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modalRoute = ModalRoute.of(context);
      if (modalRoute != null) {
        RouteObserver<ModalRoute>().subscribe(this, modalRoute);
        print('Subscribed to RouteObserver');
      } else {
        print('ModalRoute is null, RouteObserver not subscribed');
      }
    });
    _searchController.addListener(() {
      print('SearchController text changed: ${_searchController.text}');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    RouteObserver<ModalRoute>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    print('didPopNext called: Clearing TextField');
    _searchController.clear();
    setState(() {
      selectedSection = null;
      _isSearchActive = false;
      _filterScanningDetails();
    });
  }

  Future<void> _fetchScanningDetails() async {
    final String apiUrl =
        'https://www.talalgroupintl.com/stk_info_api/inv_scaning_get_scaning_record.php?shop_id=${widget.shop['id']}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        setState(() {
          scanningDetails = List<Map<String, dynamic>>.from(responseData['scanning_details']);
          _filterScanningDetails();
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

  void _filterScanningDetails() {
    setState(() {
      if (selectedSection == null) {
        filteredScanningDetails = List.from(scanningDetails);
      } else {
        filteredScanningDetails = scanningDetails.where((scan) {
          final sectionString = scan['sections'] as String? ?? '';
          final sectionList = sectionString.split(',');
          return sectionList.any((section) {
            final match = RegExp(r'^([^()]+)(\(([^()]*)\))?$').firstMatch(section.trim());
            final sectionName = match?.group(1)?.trim() ?? section.trim();
            return sectionName == selectedSection;
          });
        }).toList();
      }
    });
  }

  Future<void> _addScanningDetail({
    required String user,
    required String sections,
  }) async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/inv_scaning_form_scaning_record.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'shop_id': widget.shop['id'],
          'user': user,
          'sections': sections,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        await _fetchScanningDetails();
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

  Future<void> _updateScanningDetail({
    required int id,
    required String user,
    required String sections,
  }) async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/inv_scaning_update_records.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'user': user,
          'sections': sections,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        await _fetchScanningDetails();
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

  Future<void> _deleteScanningDetail({
    required int id,
  }) async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/delete_scanning_record.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        await _fetchScanningDetails();
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

  bool _validateSections(List<Map<String, TextEditingController>> sectionControllers) {
    final selectedSections = sectionControllers
        .map((controller) => controller['section']!.text.trim())
        .where((section) => section.isNotEmpty)
        .toList();

    final uniqueSections = selectedSections.toSet();
    if (uniqueSections.length != selectedSections.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duplicate sections are not allowed')),
      );
      return false;
    }

    for (var section in selectedSections) {
      if (!sections.contains(section)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid section: $section')),
        );
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.shop['shop_name']}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Scanning Detail',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddScanningDetailPage(shop: widget.shop),
                ),
              );
              if (result == true) {
                await _fetchScanningDetails();
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                print('ValueListenableBuilder rebuilt with text: ${value.text}');
                return Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    print('Search optionsBuilder called with: ${textEditingValue.text}, _isSearchActive: $_isSearchActive');
                    if (!_isSearchActive) {
                      print('Dropdown not shown: _isSearchActive is false');
                      return const Iterable<String>.empty();
                    }
                    final query = textEditingValue.text.toLowerCase();
                    final options = query.isEmpty
                        ? ['All Sections', ...sections]
                        : ['All Sections', ...sections]
                            .where((section) => section.toLowerCase().contains(query))
                            .toList();
                    print('Returning ${options.length} options');
                    return options;
                  },
                  onSelected: (String selection) {
                    print('Selected: $selection');
                    setState(() {
                      selectedSection = selection == 'All Sections' ? null : selection;
                      _searchController.text = selection == 'All Sections' ? '' : selection;
                      _isSearchActive = false;
                      _filterScanningDetails();
                    });
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    textEditingController.text = _searchController.text;
                    textEditingController.addListener(() {
                      print('textEditingController changed: ${textEditingController.text}');
                      if (_searchController.text != textEditingController.text) {
                        _searchController.text = textEditingController.text;
                      }
                    });
                    focusNode.addListener(() {
                      print('Autocomplete focus changed: ${focusNode.hasFocus}');
                      setState(() {
                        _isSearchActive = focusNode.hasFocus;
                      });
                    });
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      autofocus: false,
                      onTap: () {
                        print('TextField tapped');
                        setState(() {
                          _isSearchActive = true;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Search Section',
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  print('Clear button pressed');
                                  _searchController.clear();
                                  textEditingController.clear();
                                  setState(() {
                                    selectedSection = null;
                                    _isSearchActive = false;
                                    _filterScanningDetails();
                                  });
                                  focusNode.unfocus();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    print('Search optionsViewBuilder called with ${options.length} options: ${options.toList()}');
                    return Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: options.length * 50.0 < 200 ? options.length * 50.0 : 200,
                        width: MediaQuery.of(context).size.width - 32,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                print('Option tapped: $option');
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Scanning Records',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredScanningDetails.isEmpty
                  ? const Center(child: Text('No scanning records found'))
                  : ListView.builder(
                      itemCount: filteredScanningDetails.length,
                      itemBuilder: (context, index) {
                        final scan = filteredScanningDetails[index];
                        final sections = (scan['sections'] as String? ?? '').split(',');
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserScanningDetailPage(scan: scan),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(
                              'User: ${scan['user']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sections:'),
                                ...sections.map((section) {
                                  final match = RegExp(r'^([^()]+)(\(([^()]*)\))?$').firstMatch(section.trim());
                                  final sectionName = match?.group(1)?.trim() ?? section.trim();
                                  final comment = match?.group(3)?.trim() ?? '';
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: sectionName == selectedSection
                                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                          : null,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '  • $sectionName${comment.isNotEmpty ? ' ($comment)' : ''}',
                                      style: TextStyle(
                                        fontWeight: sectionName == selectedSection
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Theme.of(context).colorScheme.primary,
                                  tooltip: 'Edit Scanning Detail',
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScanningDetailPage(
                                          shop: widget.shop,
                                          scan: scan,
                                        ),
                                      ),
                                    );
                                    if (result == true) {
                                      await _fetchScanningDetails();
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}