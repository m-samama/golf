import 'package:get/get.dart';
import '../models/storage_models.dart';

class DetailsController extends GetxController {
  final selected = Rxn<StorageItem>();
  final sourcePage = ''.obs; // 'Storage','Playing','Overdue','TakeOff'

  void setItem(StorageItem item, String source) {
    selected.value = item;
    sourcePage.value = source;
  }

  void clear() {
    selected.value = null;
    sourcePage.value = '';
  }
}
