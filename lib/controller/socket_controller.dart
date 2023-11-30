import 'dart:convert';

import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';

import 'package:efood_multivendor_driver/data/model/response/profile_model.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class SocketController extends GetxController implements GetxService {
  SocketController();

  ProfileModel profileModel = Get.find<AuthController>().profileModel;

  Future<void> connectSocket(Function function) async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: "a5ac93791493bee1a004",
        cluster: 'ap2',
        onConnectionStateChange: ((currentState, previousState) {
          print('current state: $currentState');
        }),
        onError: ((message, code, error) {
          print('Error: $message');
        }),
        onSubscriptionSucceeded: ((channelName, data) {
          print('Subscription: $data');
        }),
        onEvent: ((event) {
          // print('Event: $event');

          String data = event.data;
          Map valueMap = jsonDecode(data);
          // print(valueMap['id']);

          if (event.eventName != 'new_order' &&
              profileModel.zoneId == valueMap['zone_id'] &&
              profileModel.active == 1 &&
              valueMap['delivery_man_id'] == null &&
              valueMap['order_type'] == 'delivery') {
            Get.find<OrderController>().getCurrentOrders();
            Get.find<OrderController>().getLatestOrders();

            Get.dialog(NewRequestDialog(isRequest: true, onTap: function));
          } else if (profileModel.id == valueMap['delivery_man_id']) {
            Get.find<OrderController>().getCurrentOrders();
            if (Get.find<OrderController>().orderModel.id == valueMap['id']) {
              // Get.find<OrderController>().isLoading = true;
              Get.find<OrderController>().getOrderDetails(valueMap['id']);
              Get.find<OrderController>().getOrderWithId(valueMap['id']);
            }
            // print(event.eventName);
            // print(valueMap['restaurant_id']);
          }
        }),
        
        // onSubscriptionError: onSubscriptionError,
        // onDecryptionFailure: onDecryptionFailure,
        // onMemberAdded: onMemberAdded,
        // onMemberRemoved: onMemberRemoved,
        // authEndpoint: "<Your Authendpoint>",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(
        channelName: 'efood-development',
      );
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
