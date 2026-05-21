import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewProp extends StatefulWidget {
  const NewProp({super.key});

  @override
  State<NewProp> createState() => _NewPropState();
}

class _NewPropState extends State<NewProp> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedType;
  String? _selectedRooms;
  final _titleCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  final Set<String> _selectedFacilities = {};
  final List<XFile> _selectedImages = [];
  bool _agreed = false;
  bool _submitting = false;

  static const _propertyTypes = [
    {'label': 'Apartment', 'icon': Icons.apartment_rounded},
    {'label': 'Studio', 'icon': Icons.single_bed_rounded},
    {'label': 'Villa', 'icon': Icons.villa_rounded},
    {'label': 'Room\nShare', 'icon': Icons.meeting_room_rounded},
  ];

  static const _roomOptions = ['1', '2', '3', '4', '5+'];

  static const _facilities = [
    {'label': 'WiFi', 'icon': Icons.wifi_rounded},
    {'label': 'Parking', 'icon': Icons.local_parking_rounded},
    {'label': 'AC', 'icon': Icons.ac_unit_rounded},
    {'label': 'Balcony', 'icon': Icons.balcony_rounded},
    {'label': 'Gym', 'icon': Icons.fitness_center_rounded},
    {'label': 'Garden', 'icon': Icons.yard_rounded},
    {'label': 'Furnished', 'icon': Icons.chair_rounded},
    {'label': 'Security', 'icon': Icons.security_rounded},
    {'label': 'Pool', 'icon': Icons.pool_rounded},
    {'label': 'Lift', 'icon': Icons.elevator_rounded},
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _addressCtrl.dispose();
    _areaCtrl.dispose();
    _aboutCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(maxWidth: 800, maxHeight: 600);
    if (images.isNotEmpty) setState(() => _selectedImages.addAll(images));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      _showSnack('Please select a property type');
      return;
    }
    if (!_agreed) {
      _showSnack('Please agree to the terms & conditions');
      return;
    }
    setState(() => _submitting = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Property listed successfully!',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ]),
          backgroundColor: const Color(0xFF11998E),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildCard(
                      icon: Icons.home_work_rounded,
                      title: 'Property Details',
                      children: [
                        _buildTypeSelector(),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(child: _buildRoomsDropdown()),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildField(
                                  'Rent / month', _priceCtrl,
                                  Icons.currency_rupee_rounded,
                                  keyboard: TextInputType.number,
                                  validator: _numValidator)),
                        ]),
                        const SizedBox(height: 12),
                        _buildField('Property Title', _titleCtrl,
                            Icons.title_rounded,
                            validator: _titleValidator),
                        const SizedBox(height: 12),
                        _buildField('Full Address', _addressCtrl,
                            Icons.location_on_rounded,
                            validator: _requiredValidator),
                        const SizedBox(height: 12),
                        _buildField('Area (sq ft)', _areaCtrl,
                            Icons.square_foot_rounded,
                            keyboard: TextInputType.number,
                            validator: _numValidator),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCard(
                      icon: Icons.edit_note_rounded,
                      title: 'Description',
                      children: [
                        _buildField(
                          'Tell potential renters about your property...',
                          _aboutCtrl,
                          Icons.short_text_rounded,
                          maxLines: 4,
                          validator: _requiredValidator,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCard(
                      icon: Icons.star_rounded,
                      title: 'Amenities',
                      children: [_buildFacilityChips()],
                    ),
                    const SizedBox(height: 12),
                    _buildCard(
                      icon: Icons.photo_library_rounded,
                      title: 'Property Photos',
                      children: [_buildPhotoArea()],
                    ),
                    const SizedBox(height: 20),
                    _buildTermsAndSubmit(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 150,
      pinned: true,
      backgroundColor: const Color(0xFF3D22B8),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('Save Draft',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E0B6E), Color(0xFF3D22B8), Color(0xFF6246EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'List Your Property',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Hind'),
              ),
              const SizedBox(height: 4),
              Text(
                'Reach thousands of verified renters in Guwahati',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon,
      required String title,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6246EA).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF6246EA), size: 18),
            ),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Hind')),
          ]),
          Divider(color: Colors.grey.withValues(alpha: 0.12), height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property Type',
            style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8E8E93),
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_propertyTypes.length, (i) {
            final type = _propertyTypes[i];
            final label = (type['label'] as String).replaceAll('\n', ' ');
            final selected = _selectedType == label;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = label),
                child: Container(
                  margin: EdgeInsets.only(
                      right: i < _propertyTypes.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF6246EA)
                        : const Color(0xFFF4F5F8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF6246EA)
                          : Colors.transparent,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6246EA)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Icon(type['icon'] as IconData,
                          size: 20,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF8E8E93)),
                      const SizedBox(height: 5),
                      Text(
                        type['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF555555),
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRoomsDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedRooms,
      decoration: _inputDecoration('Bedrooms', Icons.bed_rounded),
      hint: const Text('Rooms',
          style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 13)),
      items: _roomOptions
          .map((r) => DropdownMenuItem(
              value: r,
              child: Text(r,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A1A2E)))))
          .toList(),
      onChanged: (v) => setState(() => _selectedRooms = v),
    );
  }

  Widget _buildField(
    String hint,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF6246EA), size: 20),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF6246EA), width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      filled: true,
      fillColor: const Color(0xFFF8F8FA),
    );
  }

  Widget _buildFacilityChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _facilities.map((fac) {
        final label = fac['label'] as String;
        final selected = _selectedFacilities.contains(label);
        return GestureDetector(
          onTap: () => setState(() {
            if (selected) {
              _selectedFacilities.remove(label);
            } else {
              _selectedFacilities.add(label);
            }
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF6246EA)
                  : const Color(0xFFF4F5F8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? const Color(0xFF6246EA)
                    : const Color(0xFFE0E0E0),
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                          color:
                              const Color(0xFF6246EA).withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(fac['icon'] as IconData,
                    size: 14,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF8E8E93)),
                const SizedBox(width: 5),
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF555555),
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoArea() {
    if (_selectedImages.isEmpty) {
      return GestureDetector(
        onTap: _pickImages,
        child: Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFF6246EA).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF6246EA).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6246EA).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_photo_alternate_rounded,
                    color: Color(0xFF6246EA), size: 28),
              ),
              const SizedBox(height: 10),
              const Text('Tap to upload photos',
                  style: TextStyle(
                      color: Color(0xFF6246EA),
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const SizedBox(height: 2),
              const Text('Add exterior, interior & room photos',
                  style:
                      TextStyle(color: Color(0xFF8E8E93), fontSize: 11)),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            ..._selectedImages.take(5).map(_buildImageTile),
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF6246EA).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFF6246EA).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Color(0xFF6246EA), size: 28),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${_selectedImages.length} photo${_selectedImages.length == 1 ? '' : 's'} selected',
          style:
              const TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildImageTile(XFile img) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6246EA).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_rounded,
                    color: Color(0xFF6246EA), size: 24),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(img.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 8, color: Color(0xFF6246EA))),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _selectedImages.remove(img)),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child:
                  const Icon(Icons.close, color: Colors.white, size: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndSubmit() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _agreed = !_agreed),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _agreed
                    ? const Color(0xFF6246EA).withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _agreed
                        ? const Color(0xFF6246EA)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: _agreed
                            ? const Color(0xFF6246EA)
                            : const Color(0xFFCCCCCC),
                        width: 1.5),
                  ),
                  child: _agreed
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('I agree to the Terms & Conditions',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E))),
                      SizedBox(height: 2),
                      Text(
                          'Your listing will be reviewed within 24 hours',
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFF8E8E93))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _submitting ? null : _submit,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3D22B8), Color(0xFF6246EA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6246EA).withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: _submitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text('Publish Listing',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3)),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _titleValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter a title';
    if (v.length > 50) return 'Title must be under 50 characters';
    return null;
  }

  String? _numValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    if (int.tryParse(v.trim()) == null) return 'Enter a valid number';
    return null;
  }
}
