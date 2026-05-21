import 'package:flutter/material.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/models/filterscreenresult.dart';
import '../models/options.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues values = const RangeValues(0, 100000);
  List<Facility> selectedFacilities = [];
  List<Options> selectedPropertyTypes = [];

  static final List<Facility> _facilities = [
    Facility(id: 1, facility: 'WiFi'),
    Facility(id: 2, facility: 'Parking'),
    Facility(id: 3, facility: 'Gym'),
    Facility(id: 4, facility: 'Swimming Pool'),
    Facility(id: 5, facility: 'Security'),
    Facility(id: 6, facility: 'Power Backup'),
    Facility(id: 7, facility: 'Lift'),
    Facility(id: 8, facility: 'Garden'),
  ];

  static final List<Options> _propertyTypes = [
    Options(id: 1, name: 'Apartment'),
    Options(id: 2, name: 'Studio'),
    Options(id: 3, name: 'Villa'),
    Options(id: 4, name: 'Room Share'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF6246EA), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter Properties',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Hind',
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price Range',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Hind',
                            fontSize: 18,
                            color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 4),
                    Text(
                      'Rs ${values.start.round()} — Rs ${values.end.round()} /month',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6246EA),
                          fontWeight: FontWeight.w600),
                    ),
                    RangeSlider(
                      values: values,
                      min: 0,
                      max: 100000,
                      divisions: 20,
                      activeColor: const Color(0xFF6246EA),
                      inactiveColor: const Color(0xFFE0E0E0),
                      onChanged: (v) => setState(() => values = v),
                    ),
                    const SizedBox(height: 20),
                    const Text('Property Type',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Hind',
                            fontSize: 18,
                            color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _propertyTypes.map((pt) {
                        final selected = selectedPropertyTypes.contains(pt);
                        return GestureDetector(
                          onTap: () => setState(() {
                            selected
                                ? selectedPropertyTypes.remove(pt)
                                : selectedPropertyTypes.add(pt);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF6246EA)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF6246EA)
                                    : const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Text(
                              pt.name,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF555555),
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text('Facilities',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Hind',
                            fontSize: 18,
                            color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _facilities.map((f) {
                        final selected = selectedFacilities.contains(f);
                        return GestureDetector(
                          onTap: () => setState(() {
                            f.isSelected = !f.isSelected;
                            selected
                                ? selectedFacilities.remove(f)
                                : selectedFacilities.add(f);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF6246EA)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF6246EA)
                                    : const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Text(
                              f.facility,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF555555),
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    FilterScreenResult(
                      values: values,
                      selectedFacilities: selectedFacilities,
                      selectedPropType: selectedPropertyTypes,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6246EA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
