import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddScanningDetailPage extends StatefulWidget {
  final Map<String, dynamic> shop;

  const AddScanningDetailPage({super.key, required this.shop});

  @override
  State<AddScanningDetailPage> createState() => _AddScanningDetailPageState();
}

class _AddScanningDetailPageState extends State<AddScanningDetailPage> {
  final TextEditingController _userController = TextEditingController();
  List<Map<String, dynamic>> sectionControllers = [];
  bool _isButtonPressed = false;

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
    'CHECKOUT AREA ',
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
    'FOOD PRODUCTS-SUGAR & SUGAR SUBSTITUTE AND SARBATH',
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
  void dispose() {
    _userController.dispose();
    for (var controller in sectionControllers) {
      controller['section']?.dispose();
      controller['comment']?.dispose();
    }
    super.dispose();
  }

  // Validate sections to prevent duplicates and invalid entries
  bool _validateSections() {
    final selectedSections = sectionControllers
        .map((controller) => controller['section']!.text.trim())
        .where((section) => section.isNotEmpty)
        .toList();

    final uniqueSections = selectedSections.toSet();
    if (uniqueSections.length != selectedSections.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duplicate sections are not allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    for (var section in selectedSections) {
      if (!sections.contains(section)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid section: $section'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    return true;
  }

  // Send scanning details to backend
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
      print('Submission response: ${response.body}'); // Debug log

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Signal refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${responseData['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Submission error: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to connect to the server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show dialog to select a section
//   void _showAddSectionDialog() {
//   final sectionController = TextEditingController();
//   final commentController = TextEditingController();
//   bool isDialogButtonPressed = false;
//   File? selectedImage;

//   final ImagePicker picker = ImagePicker();

// showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             title: const Text(
//               'Add Section',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Autocomplete<String>(
//                     optionsBuilder: (TextEditingValue textEditingValue) {
//                       if (textEditingValue.text.isEmpty) {
//                         return sections;
//                       }
//                       return sections.where((String section) =>
//                           section.toLowerCase().contains(textEditingValue.text.toLowerCase()));
//                     },
//                     onSelected: (String selection) {
//                       sectionController.text = selection;
//                     },
//                     fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
//                       textEditingController.text = sectionController.text;
//                       textEditingController.addListener(() {
//                         sectionController.text = textEditingController.text;
//                       });
//                       return TextField(
//                         controller: textEditingController,
//                         focusNode: focusNode,
//                         decoration: InputDecoration(
//                           labelText: 'Section',
//                           prefixIcon: Icon(Icons.category, color: Colors.blue[800]),
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                           suffixIcon: textEditingController.text.isNotEmpty
//                               ? IconButton(
//                                   icon: Icon(Icons.clear, color: Colors.grey[600]),
//                                   onPressed: () {
//                                     textEditingController.clear();
//                                     sectionController.clear();
//                                     FocusScope.of(context).unfocus();
//                                   },
//                                 )
//                               : null,
//                         ),
//                       );
//                     },
//                     optionsViewBuilder: (context, onSelected, options) {
//                       return Align(
//                         alignment: Alignment.topLeft,
//                         child: Material(
//                           elevation: 4.0,
//                           borderRadius: BorderRadius.circular(8),
//                           child: ConstrainedBox(
//                             constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: options.length,
//                               itemBuilder: (context, index) {
//                                 final option = options.elementAt(index);
//                                 return ListTile(
//                                   title: Text(
//                                     option,
//                                     style: Theme.of(context).textTheme.bodyMedium,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   onTap: () => onSelected(option),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: commentController,
//                     decoration: InputDecoration(
//                       labelText: 'Comment (optional)',
//                       prefixIcon: Icon(Icons.comment, color: Colors.blue[800]),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () async {
//                           final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//                           if (image != null) {
//                             setDialogState(() {
//                               selectedImage = File(image.path);
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.image),
//                         label: const Text('Upload Image'),
//                       ),
//                       const SizedBox(width: 12),
//                       if (selectedImage != null)
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(
//                             selectedImage!,
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
//               ),
//               GestureDetector(
//                 onTapDown: (_) {
//                   setDialogState(() {
//                     isDialogButtonPressed = true;
//                   });
//                 },
//                 onTapUp: (_) {
//                   setDialogState(() {
//                     isDialogButtonPressed = false;
//                   });

//                   final section = sectionController.text.trim();
//                   final comment = commentController.text.trim();

//                   if (section.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please select a section'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                     return;
//                   }
//                   if (!sections.contains(section)) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Invalid section: $section'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                     return;
//                   }
//                   if (comment.contains(',')) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Commas are not allowed in the comment'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                     return;
//                   }

//                   setState(() {
//                     sectionControllers.add({
//                       'section': TextEditingController(text: section),
//                       'comment': TextEditingController(text: comment),
//                       'image': selectedImage, // Optional use
//                     });
//                   });

//                   Navigator.pop(context);
//                 },
//                 onTapCancel: () {
//                   setDialogState(() {
//                     isDialogButtonPressed = false;
//                   });
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 100),
//                   transform: Matrix4.identity()..scale(isDialogButtonPressed ? 0.95 : 1.0),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue[700]!, Colors.teal[400]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ElevatedButton(
//                     onPressed: null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                     ),
//                     child: const Text(
//                       'Submit',
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Scanning Detail'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: 'User',
                  prefixIcon: Icon(Icons.person, color: Colors.blue[800]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelStyle: TextStyle(color: Colors.grey[700]),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sectionControllers.length,
                itemBuilder: (context, index) {
                  final controllers = sectionControllers[index];
                  final sectionText = controllers['section']!.text;
                  final commentText = controllers['comment']!.text;
                  final displayText = commentText.isEmpty
                      ? sectionText
                      : '$sectionText ($commentText)';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Icon(Icons.category, color: Colors.blue[800]),
                        title: Text(
                          displayText.isEmpty ? 'No Section' : displayText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: displayText.isEmpty ? Colors.grey : Colors.black87,
                          ),
                          maxLines: 3, // Allow up to 3 lines
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              sectionControllers.removeAt(index);
                            });
                          },
                          child: AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // const SizedBox(height: 12),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTapDown: (_) {
              //       setState(() {
              //         _isButtonPressed = true;
              //       });
              //     },
              //     onTapUp: (_) {
              //       setState(() {
              //         _isButtonPressed = false;
              //       });
              //       _showAddSectionDialog();
              //     },
              //     onTapCancel: () {
              //       setState(() {
              //         _isButtonPressed = false;
              //       });
              //     },
              //     child: AnimatedContainer(
              //       duration: const Duration(milliseconds: 100),
              //       transform: Matrix4.identity()..scale(_isButtonPressed ? 0.95 : 1.0),
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [Colors.blue[700]!, Colors.teal[400]!],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //         borderRadius: BorderRadius.circular(12),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.blue.withOpacity(0.3),
              //             blurRadius: 8,
              //             offset: const Offset(0, 4),
              //           ),
              //         ],
              //       ),
              //       child: ElevatedButton(
              //         onPressed: null,
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              //         ),
              //         child: const Text(
              //           'Add Section',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isButtonPressed = true;
                      });
                    },
                    onTapUp: (_) async {
                      setState(() {
                        _isButtonPressed = false;
                      });
                      final user = _userController.text.trim();
                      for (final controller in sectionControllers) {
                        final comment = controller['comment']!.text.trim();
                        if (comment.contains(',')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Commas are not allowed in the comment'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }
                      final sectionsString = sectionControllers
                          .map((controller) {
                            final section = controller['section']!.text.trim();
                            final comment = controller['comment']!.text.trim();
                            if (section.isEmpty) return null;
                            return comment.isEmpty ? section : '$section($comment)';
                          })
                          .where((section) => section != null)
                          .join(',');
                      if (user.isNotEmpty) {
                        if (_validateSections()) {
                          await _addScanningDetail(user: user, sections: sectionsString);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill user and at least one section'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    onTapCancel: () {
                      setState(() {
                        _isButtonPressed = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      transform: Matrix4.identity()..scale(_isButtonPressed ? 0.95 : 1.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[700]!, Colors.teal[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}