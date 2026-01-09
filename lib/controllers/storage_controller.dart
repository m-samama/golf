import 'package:get/get.dart';
import '../models/storage_models.dart';

class StorageController extends GetxController {
  final items = <StorageItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Mock / local sample data so backend is not required to test UI
  void fetchData() {
    items.assignAll([
      StorageItem(
        id: '1',
        name: 'Alex Johnson',
        phone: '0325478596',
        dateRange: 'Jan 10 - Feb 10',
        status: 'Overdue',
        image: 'assets/images/bag.jpg',
        checkInDate: '22/01/2023',
        packageDuration: '1 Month',
        position: 'R2 - C15',
        clubsCount: 14,
      ),
      StorageItem(
        id: '2',
        name: 'Sarah Ahmed',
        phone: '0312345678',
        dateRange: 'Jan 10 - Feb 10',
        status: 'Playing',
        image: 'assets/images/bag.jpg',
        checkInDate: '20/02/2023',
        packageDuration: '1 Month',
        position: 'R2 - C10',
        clubsCount: 14,
      ),
      StorageItem(
        id: '3',
        name: 'Bilal Khan',
        phone: '0300123456',
        dateRange: 'Jan 10 - Feb 10',
        status: 'Overdue',
        image: 'assets/images/bag.jpg',
        checkInDate: '05/03/2023',
        packageDuration: '3 Months',
        position: 'R3 - A02',
        clubsCount: 10,
      ),
      StorageItem(
        id: '4',
        name: 'Qasim Khan',
        phone: '0300123456',
        dateRange: 'Jan 10 - Feb 10',
        status: 'TakeOff',
        image: 'assets/images/bag.jpg',
        checkInDate: '01/01/2023',
        
        packageDuration: 'Expired',
        position: 'R4 - B01',
        clubsCount: 12,
      ),
    ]);
  }

  List<StorageItem> filterByStatus(String status) {
    if (status == 'All' || status == 'Storage') {
      // Storage screen shows items with status 'Storage' OR all items depending on your design
      return items.where((i) => i.status == 'Storage').toList();
    }
    return items.where((i) => i.status == status).toList();
  }

  StorageItem? findById(String id) {
    try {
      return items.firstWhere((i) => i.id == id);
    } catch (e) {
      return null;
    }
  }
}
