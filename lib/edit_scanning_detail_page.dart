import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

// Custom styles for the inventory app
const _primaryColor = Color(0xFF1976D2); // Blue
const _secondaryColor = Color(0xFF26A69A); // Teal
const _backgroundColor = Color(0xFFFFFFFF); // White
const _surfaceColor = Color(0xFFF5F5F5); // Light grey
const _errorColor = Color(0xFFD32F2F); // Red
const _successColor = Color(0xFF388E3C); // Green
const _textColor = Color(0xFF212121); // Dark grey
const _disabledColor = Color(0xFFB0BEC5); // Grey for disabled
const _borderRadius = 12.0;
const _padding = EdgeInsets.all(16.0);
const _buttonPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 24);
const _fontFamily = 'Roboto';

final _themeData = ThemeData(
  primaryColor: _primaryColor,
  colorScheme: ColorScheme.light(
    primary: _primaryColor,
    secondary: _secondaryColor,
    surface: _surfaceColor,
    background: _backgroundColor,
    error: _errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: _textColor,
    onBackground: _textColor,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: _backgroundColor,
  appBarTheme: AppBarTheme(
    elevation: 4,
    shadowColor: Colors.black26,
    titleTextStyle: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textColor),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _textColor),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]),
    labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: _primaryColor, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: _disabledColor),
    ),
    labelStyle: TextStyle(color: Colors.grey[600]),
    prefixIconColor: _primaryColor,
  ),
  cardTheme: CardTheme(
    elevation: 2,
    color: _surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      side: BorderSide(color: Colors.grey[300]!),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      padding: _buttonPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.grey[400]!),
      padding: _buttonPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: _backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
    elevation: 4,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _primaryColor,
    contentTextStyle: TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
  ),
);

class EditScanningDetailPage extends StatefulWidget {
  final Map<String, dynamic> shop;
  final Map<String, dynamic> scan;

  const EditScanningDetailPage({super.key, required this.shop, required this.scan});

  @override
  State<EditScanningDetailPage> createState() => _EditScanningDetailPageState();
}

class _EditScanningDetailPageState extends State<EditScanningDetailPage> {
  final TextEditingController _userController = TextEditingController();
  List<Map<String, dynamic>> sectionControllers = [];
  bool _isLoading = false;

  static const List<String> _sections = [
    'BAGS & TROLLEY-BACK PACK',
    'BAGS & TROLLEY-HAND BAG',
    'BAGS & TROLLEY-TROLLEY BAG',
    'BAKERY PRODUCTS-CAKES & SNACKS',
    'BAKERY PRODUCTS-PASTRIES',
    'BAKERY PRODUCTS-READY TO EAT',
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
    'CHILLED & DAIRY-BATTER & READY TO COOK',
    'CHILLED & DAIRY-CHEESE & LABNEH',
    'CHILLED & DAIRY-DAIRY PRODUCTS',
    'CHILLED & DAIRY-EGGS',
    'CONFECTIONERY-CHIPS',
    'CONFECTIONERY-CHOCOLATES',
    'COSMETICS-BABY CARE',
    'COSMETICS-BATH & BODY CARE',
    'COSMETICS-HAIR CARE',
    'COSMETICS-HEALTH & BEAUTY',
    'COSMETICS-HEALTH CARE EQUIPMENT',
    'COSMETICS-ORAL CARE',
    'COSMETICS-PERFUMES & DEO',
    'CHECKOUT AREA',
    'DETERGENTS-CLEANING ACCESSORIES',
    'DETERGENTS-CLEANING AGENTS',
    'DETERGENTS-DISH WASH',
    'DETERGENTS-HOME FRAGRANCE',
    'DETERGENTS-INSECT KILLER',
    'DETERGENTS-LAUNDRY',
    'DETERGENTS-SHOE POLISH & BRUSH',
    'DETERGENTS-SPRAY CLEANERS',
    'DETERGENTS-WC FRESHENER',
    'ELECTRONICS-AUDIO & MUSIC',
    'ELECTRONICS-CAMERA & LENS AND ACCESSORIES',
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
    'FASHION ACCESSORIES-SUNGLASSES',
    'FASHION ACCESSORIES-WALLET',
    'FISHERY-DRY FISH',
    'FISHERY-FROZEN FISH',
    'FOOD PRODUCTS-AFRICAN FOOD',
    'FOOD PRODUCTS-BABY FOOD',
    'FOOD PRODUCTS-BAKING AND DESSERT INGREDIENTS',
    'FOOD PRODUCTS-CANNED',
    'FOOD PRODUCTS-CORNFLAKES & CEREALS',
    'FOOD PRODUCTS-INSTANT DRINK',
    'FOOD PRODUCTS-JAMS & SPREADS',
    'FOOD PRODUCTS-MILK PRODUCTS',
    'FOOD PRODUCTS-MIXTURE & SNACKS',
    'FOOD PRODUCTS-NOODLES & SOUP',
    'FOOD PRODUCTS-OIL & GHEE',
    'FOOD PRODUCTS-ORGANIC',
    'FOOD PRODUCTS-PASTA',
    'FOOD PRODUCTS-PRESERVED',
    'FOOD PRODUCTS-SAUCE & DRESSING',
    'FOOD PRODUCTS-SUGAR & SUGAR SUBSTITUTE AND SHERBET',
    'FOOD PRODUCTS-TEA & COFFEE',
    'FOOTWEAR-KIDS',
    'FOOTWEAR-LADIES SANDAL',
    'FOOTWEAR-LADIES',
    'FOOTWEAR-MENS SANDAL',
    'FOOTWEAR-MENS SHOE',
    'FOOTWEAR-SAFETY',
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
    'GARMENTS-UNDERGARMENTS KIDS',
    'GARMENTS-UNDERGARMENTS MEN',
    'GARMENTS-UNDERGARMENTS WOMEN',
    'GARMENTS-WINTER ITEMS',
    'GIFT-FLOWERS',
    'GIFT-STAND AND HOLDERS',
    'GIFT-STATUE AND FRAMES',
    'HEALTH CARE-HEALTH SUPPLEMENTS',
    'HEALTH CARE-PAIN RELIEVERS',
    'HOUSEHOLD',
    'HOUSEHOLD-CROCKERY',
    'HOUSEHOLD-DISPOSABLES & TISSUES',
    'HOUSEHOLD-HARDWARE TOOLS & ACCESSORIES',
    'HOUSEHOLD-HOME ACCESSORIES',
    'HOUSEHOLD-HOME APPLIANCES',
    'HOUSEHOLD-HOME DECOR',
    'HOUSEHOLD-KITCHEN TOOLS',
    'HOUSEHOLD-PLASTIC PRODUCTS',
    'MASALA-CURRY POWDER & SPICES',
    'MASALA-ESSENCES & COLORS',
    'MASALA-FLOURS',
    'MASALA-OTHER GRAINS',
    'MASALA-PULSES',
    'MASALA-READY TO COOK',
    'MASALA-RICE BAG',
    'MASALA-SALT',
    'MOBILE PHONE & ACCESSORIES',
    'PERFUME & DEODORANT',
    'PET SUPPLIES-PET ACCESSORIES',
    'PET SUPPLIES-PET FOOD',
    'SMOKING ACCESSORIES',
    'STATIONERY-TRAVEL ACCESSORIES',
    'STATIONERY-BOOKS & PAPER',
    'STATIONERY-CARDIO & EXERCISE ACCESSORIES',
    'STATIONERY-CYCLE & SCOOTER',
    'STATIONERY-HUNTING & FISHING',
    'STATIONERY-MAGAZINE & NEWSPAPER',
    'STATIONERY-OFFICE & EDUCATIONAL SUPPLIES',
    'STATIONERY-SPORTS TOOLS',
    'STATIONERY-TAILORING',
    'TOYS & DOLLS-DOLLS',
    'TOYS & DOLLS-TOYS',
    'WATCH-GENTS WATCH',
    'WATCH-KIDS WATCH',
    'WATCH-LADIES WATCH',
  ];

  @override
  void initState() {
    super.initState();
    _userController.text = widget.scan['user'] ?? '';
    final sectionsList = widget.scan['sections'] as List<dynamic>? ?? [];

    for (var section in sectionsList) {
      final sId = section['s_id'];
      print('✅ s_id loaded: $sId'); // Debug log

      sectionControllers.add({
        'section': TextEditingController(text: section['section'] as String? ?? ''),
        'comment': TextEditingController(text: section['comment'] as String? ?? ''),
        's_id': sId, // Store s_id for deletion
        'image': null,
        'imageUrl': section['image'] as String?,
      });
    }

    print('✅ Total sections loaded: ${sectionControllers.length}');
  }

  @override
  void dispose() {
    _userController.dispose();
    for (var controller in sectionControllers) {
      controller['section']?.dispose();
      controller['comment']?.dispose();
    }
    super.dispose();
  }

  bool _validateSections() {
    final selectedSections = sectionControllers
        .map((controller) => controller['section']!.text.trim())
        .where((section) => section.isNotEmpty)
        .toList();

    for (var section in selectedSections) {
      if (!_sections.contains(section)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid section: $section'),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return false;
      }
    }
    return true;
  }

  Future<bool> _saveSections(List<Map<String, dynamic>> sectionsToSave, {File? newImage, int? newImageIndex}) async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/inv_scaning_update_records.php';

    try {
      final user = _userController.text.trim();
      if (user.isEmpty || sectionsToSave.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill user and at least one section'),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return false;
      }

      if (widget.scan['id'] == null || widget.scan['id'] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid scanning record ID'),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return false;
      }

      final sectionsData = sectionsToSave.asMap().entries.map((entry) {
        final index = entry.key;
        final controller = entry.value;
        final section = controller['section']!.text.trim();
        final comment = controller['comment']!.text.trim();
        return {
          'section': section,
          'comment': comment.isNotEmpty ? comment : null,
          'image_index': controller['image'] != null ? index : (newImage != null && newImageIndex == index ? index : null),
        };
      }).where((section) => section['section'].isNotEmpty).toList();

      print('Sending sections: $sectionsData');

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['scanning_record_id'] = widget.scan['id'].toString();
      request.fields['user'] = user;
      request.fields['shop_id'] = widget.shop['id']?.toString() ?? '1';
      request.fields['sections'] = jsonEncode(sectionsData);

      for (var i = 0; i < sectionsToSave.length; i++) {
        final image = sectionsToSave[i]['image'] as File?;
        if (image != null) {
          print('Adding image_$i: ${image.path}');
          request.files.add(await http.MultipartFile.fromPath(
            'image_$i',
            image.path,
            filename: image.path.split('/').last,
          ));
        } else if (newImage != null && newImageIndex == i) {
          print('Adding new image_$i: ${newImage.path}');
          request.files.add(await http.MultipartFile.fromPath(
            'image_$i',
            newImage.path,
            filename: newImage.path.split('/').last,
          ));
        }
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      print('API Response: ${responseData.body}');

      final json = jsonDecode(responseData.body);

      if (response.statusCode == 200 && json['success']) {
        // Assign s_ids to sections
        final sIds = json['s_ids'] as List<dynamic>? ?? [];
        for (var i = 0; i < sIds.length && i < sectionsToSave.length; i++) {
          sectionsToSave[i]['s_id'] = sIds[i];
          print('Assigned s_id: ${sIds[i]} to section $i'); // Debug log
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sections saved successfully'),
            backgroundColor: _successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: ${json['message'] ?? 'Unknown error'}'),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return false;
      }
    } catch (e) {
      print('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to the server: $e'),
          backgroundColor: _errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        ),
      );
      return false;
    }
  }

  Future<bool> _removeSection(int sId) async {
    const String apiUrl = 'https://www.talalgroupintl.com/stk_info_api/inv_scaning_remove_section.php';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['s_id'] = sId.toString();

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      print('Remove Section API Response: ${responseData.body}');

      final json = jsonDecode(responseData.body);

      if (response.statusCode == 200 && json['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Section deleted successfully'),
            backgroundColor: _successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: ${json['message'] ?? 'Unknown error'}'),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          ),
        );
        return false;
      }
    } catch (e) {
      print('Delete error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to the server: $e'),
          backgroundColor: _errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        ),
      );
      return false;
    }
  }

  Future<void> _updateScanningDetail() async {
    // if (!_validateSections()) return;

    // setState(() => _isLoading = true);
    // final success = await _saveSections(sectionControllers);
    // setState(() => _isLoading = false);

    // if (success) {
      Navigator.pop(context, true);
    //}
  }

  void _showAddSectionDialog() {
    final sectionController = TextEditingController();
    final commentController = TextEditingController();
    File? selectedImage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetAnimationDuration: Duration(milliseconds: 300),
              insetAnimationCurve: Curves.easeInOut,
              child: Container(
                padding: _padding,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.add_circle, color: _primaryColor),
                        title: Text('Add Section', style: _themeData.textTheme.titleLarge),
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) return _sections;
                          return _sections.where((String section) =>
                              section.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (String selection) {
                          sectionController.text = selection;
                        },
                        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                          textEditingController.text = sectionController.text;
                          textEditingController.addListener(() {
                            sectionController.text = textEditingController.text;
                          });
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Section',
                              prefixIcon: Icon(Icons.category, color: _primaryColor),
                              suffixIcon: textEditingController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                                      onPressed: () {
                                        textEditingController.clear();
                                        sectionController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(_borderRadius),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option, style: _themeData.textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: 'Comment (optional)',
                          prefixIcon: Icon(Icons.comment, color: _primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.camera_alt),
                            label: Text('Take Photo'),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.camera);
                              if (pickedFile != null) {
                                setDialogState(() {
                                  selectedImage = File(pickedFile.path);
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.image),
                            label: Text('Choose Image'),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setDialogState(() {
                                  selectedImage = File(pickedFile.path);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage!,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: _errorColor),
                                onPressed: () {
                                  setDialogState(() {
                                    selectedImage = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              final section = sectionController.text.trim();
                              final comment = commentController.text.trim();

                              if (section.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select a section'),
                                    backgroundColor: _errorColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
                                  ),
                                );
                                return;
                              }
                              if (!_sections.contains(section)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid section: $section'),
                                    backgroundColor: _errorColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
                                  ),
                                );
                                return;
                              }
                              if (comment.contains(',')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Commas are not allowed in the comment'),
                                    backgroundColor: _errorColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
                                  ),
                                );
                                return;
                              }

                              final newSection = {
                                's_id': null, // Will be set after saving
                                'section': TextEditingController(text: section),
                                'comment': TextEditingController(text: comment),
                                'image': selectedImage,
                                'imageUrl': null,
                              };

                              setDialogState(() => _isLoading = true);
                              final success = await _saveSections(
                                [newSection],
                                newImage: selectedImage,
                                newImageIndex: 0,
                              );
                              setDialogState(() => _isLoading = false);

                              if (success) {
                                setState(() {
                                  sectionControllers.add(newSection);
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    final sectionToDelete = sectionControllers[index]['section']!.text;
    final sId = sectionControllers[index]['s_id'];
    print('Attempting to delete section with s_id: $sId'); // Debug log

    if (sId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot delete section: No section ID available'),
          backgroundColor: _errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetAnimationDuration: Duration(milliseconds: 300),
          insetAnimationCurve: Curves.easeInOut,
          child: Container(
            padding: _padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.delete, color: _errorColor),
                  title: Text('Confirm Delete Section', style: _themeData.textTheme.titleLarge),
                ),
                Padding(
                  padding: _padding,
                  child: Text(
                    'Are you sure you want to delete "$sectionToDelete"?',
                    style: _themeData.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final removedSection = sectionControllers[index];
                        setState(() {
                          sectionControllers.removeAt(index);
                        });

                        setState(() => _isLoading = true);
                        final success = await _removeSection(sId);
                        setState(() => _isLoading = false);

                        if (!success) {
                          setState(() {
                            sectionControllers.insert(index, removedSection);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete section'),
                              backgroundColor: _errorColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
                            ),
                          );
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: _errorColor),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text('Edit Scanning Detail'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: _padding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: 'User name (disabled)',
                      child: TextField(
                        controller: _userController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'User',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: sectionControllers.length,
                        itemBuilder: (context, index) {
                          final controllers = sectionControllers[index];
                          final sectionText = controllers['section']!.text;
                          final commentText = controllers['comment']!.text;
                          final image = controllers['image'] as File?;
                          final imageUrl = controllers['imageUrl'] as String?;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          image,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              'https://www.talalgroupintl.com/stk_info_api/$imageUrl',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(
                                                Icons.broken_image,
                                                color: _disabledColor,
                                              ),
                                            ),
                                          )
                                        : Icon(Icons.category, color: _primaryColor),
                                title: Text(
                                  sectionText,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
                                ),
                                subtitle: commentText.isNotEmpty
                                    ? Text(
                                        commentText,
                                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                                      )
                                    : null,
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: _errorColor),
                                  onPressed: () => _showDeleteConfirmationDialog(index),
                                  tooltip: 'Delete section',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _showAddSectionDialog,
                        child: Text('Add Section'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _updateScanningDetail,
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}