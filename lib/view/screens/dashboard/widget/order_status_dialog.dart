import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderStatusDialog extends StatefulWidget {
  final String orderStatus;
  final String orderid;

  OrderStatusDialog({
    @required this.orderStatus,
    @required this.orderid,
  });

  @override
  State<OrderStatusDialog> createState() => _OrderStatusDialogState();
}

class _OrderStatusDialogState extends State<OrderStatusDialog> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _startAlarm() {
    AudioCache _audio = AudioCache();
    _audio.play('notification.mp3');
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _audio.play('notification.mp3');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(Images.notification_in,
              height: 60, color: Theme.of(context).primaryColor),
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              'Order Status changed to ${widget.orderStatus}',
              textAlign: TextAlign.center,
              style:
                  robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          CustomButton(
            height: 40,
            buttonText: 'ok'.tr,
            onPressed: () {
              _timer?.cancel();
              Get.back();
              Get.currentRoute == RouteHelper.orderDetails ? Get.offNamed(
                RouteHelper.getOrderDetailsRoute(
                  int.parse(widget.orderid),
                ),
                arguments: OrderDetailsScreen(
                  orderId: int.parse(widget.orderid),
                  isRunningOrder: true,
                  orderIndex: 0,
                ),
              ) : Get.toNamed(
                RouteHelper.getOrderDetailsRoute(
                  int.parse(widget.orderid),
                ),
                arguments: OrderDetailsScreen(
                  orderId: int.parse(widget.orderid),
                  isRunningOrder: true,
                  orderIndex: 0,
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
