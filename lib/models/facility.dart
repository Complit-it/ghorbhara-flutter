class Facility {
  final int id;
  final String facility;
  bool isSelected;

  Facility({required this.id, required this.facility, this.isSelected = false});
  @override
  String toString() {
    return 'Facility{id: $id, facility: $facility, isSelected: $isSelected}';
  }
}
