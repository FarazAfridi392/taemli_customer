import 'package:efood_multivendor_driver/data/model/response/checkbox_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckboxController extends GetxController {
  RxList<CheckboxModel> items = <CheckboxModel>[].obs;
  RxBool isProcessing = false.obs;

  Future<void> addItemToList(CheckboxModel item) async {
    items.add(item);
  }

  void toggleItemSelection(int index) {
    items[index].isSelected = !items[index].isSelected;
    update();
  }

  Future<void> saveListToSharedPreferences() async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      // Simulate an asynchronous operation (e.g., API call, database query) to get a unique order id.
      // Replace this with your actual logic to generate the unique order id.
      await Future.delayed(Duration(seconds: 2));
      String uniqueOrderId = DateTime.now().millisecondsSinceEpoch.toString();

      List<String> selectedItems = items
          .where((item) => item.isSelected)
          .map((item) => item.title)
          .toList();

      // Save the list of selected items and the unique order id to shared preferences.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(uniqueOrderId, selectedItems);

      // Reset the state of the items and the processing flag.
      items.forEach((item) => item.isSelected = false);
      isProcessing.value = false;

      // Show a success message or navigate to another screen.
      Get.snackbar('Success', 'Items added to order $uniqueOrderId');
    } catch (e) {
      // Handle errors if necessary.
      isProcessing.value = false;
      Get.snackbar('Error', 'Failed to save items: $e');
    }
  }
}
