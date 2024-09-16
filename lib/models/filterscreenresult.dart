import 'package:flutter/material.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/models/options.dart';

class FilterScreenResult {
  final RangeValues values;
  final List<Facility> selectedFacilities;
  final List<Options> selectedPropType;

  FilterScreenResult({
    required this.values,
    required this.selectedFacilities,
    required this.selectedPropType,
  });

  @override
  String toString() {
    return 'FilterScreenResult{values: $values, selectedFacilities: $selectedFacilities, selectedPropType: $selectedPropType}';
  }
}
