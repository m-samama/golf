class StorageItem {
  final String id;
  final String name;
  final String phone;
  final String dateRange;
  final String status; // 'Storage' | 'Playing' | 'Overdue' | 'TakeOff'
  final String image;
  final String checkInDate;
  final String packageDuration;
  final String position;
  final int clubsCount;

  StorageItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.dateRange,
    required this.status,
    required this.image,
    required this.checkInDate,
    required this.packageDuration,
    required this.position,
    required this.clubsCount,
  });
}
