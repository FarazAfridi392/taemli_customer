import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/delivery_man_arrival_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialog extends StatefulWidget {
  final bool isRequest;
  final Function onTap;
  // final int orderId;
  NewRequestDialog({
    @required this.isRequest,
    @required this.onTap,
    // @required this.orderId,
  });

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {
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
    _timer = Timer.periodic(Duration(seconds: 9), (timer) {
      _audio.play('notification.mp3');
    });
  }

  @override
  Widget build(BuildContext context) {
    CountDownController controller = CountDownController();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_LARGE,
        ),
        child: GetBuilder<OrderController>(
          builder: (orderController) {
            return orderController.latestOrderList == null ||
                    orderController.latestOrderList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.close,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'New Order',
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              'Pick up:  ',
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Colors.grey),
                            ),
                            Flexible(
                              child: Text(
                                '${orderController.latestOrderList[0].restaurantName}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              'Destination: ',
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Colors.grey),
                            ),
                            Flexible(
                              child: Text(
                                '${orderController.latestOrderList[0].deliveryAddress.address}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   '${(orderController.latestOrderList[0].distance + orderController.latestOrderList[0].distanceDriverRestaurant).toStringAsFixed(2)} | ',
                            //   textAlign: TextAlign.center,
                            //   style: robotoRegular.copyWith(
                            //     fontSize: Dimensions.FONT_SIZE_LARGE,
                            //   ),
                            // ),
                            Text(
                              '${orderController.latestOrderList[0].restaurantDeliveryTime}  min',
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),

                      Text(
                        '\$${orderController.latestOrderList[0].deliveryCharge}',
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: CustomButton(
                                width: MediaQuery.of(context).size.width / 3,
                                buttonText: 'accept'.tr,
                                onPressed: () => Get.dialog(
                                    ConfirmationDialog(
                                      icon: Images.warning,
                                      title: 'are_you_sure_to_accept'.tr,
                                      description:
                                          'you_want_to_accept_this_order'.tr,
                                      onYesPressed: () {
                                        // orderController
                                        //     .acceptOrder(

                                        Get.dialog(
                                          DeliveryManArrivalDialog(
                                            icon: Images.warning,
                                            title: 'are_you_sure_to_confirm'.tr,
                                            description:
                                                'Enter arrival time in minutes'
                                                    .tr,
                                            onPressed: (String time) {
                                              print(
                                                  '======================== THIS');
                                              Get.back();
                                              orderController
                                                  .acceptOrder(
                                                orderController
                                                    .latestOrderList[0].id,
                                                0,
                                                time,
                                                orderController
                                                    .latestOrderList[0],
                                              )
                                                  .then(
                                                (isSuccess) {
                                                  if (isSuccess) {
                                                    print('accepted');
                                                    Get.back();
                                                    orderController
                                                        .latestOrderList[0]
                                                        .orderStatus = (orderController
                                                                    .latestOrderList[
                                                                        0]
                                                                    .orderStatus ==
                                                                'pending' ||
                                                            orderController
                                                                    .latestOrderList[
                                                                        0]
                                                                    .orderStatus ==
                                                                'confirmed')
                                                        ? 'accepted'
                                                        : orderController
                                                            .latestOrderList[0]
                                                            .orderStatus;
                                                    _timer?.cancel();
                                                    Get.back();
                                                    Get.toNamed(
                                                      RouteHelper
                                                          .getOrderDetailsRoute(
                                                              orderController
                                                                  .latestOrderList[
                                                                      0]
                                                                  .id),
                                                      arguments:
                                                          OrderDetailsScreen(
                                                        orderId: orderController
                                                            .latestOrderList[0]
                                                            .id,
                                                        isRunningOrder: true,
                                                        orderIndex: orderController
                                                                .currentOrderList
                                                                .length -
                                                            1,
                                                      ),
                                                    );
                                                  } else {
                                                    print('not accepted');
                                                    _timer.cancel();
                                                    Get.back();
                                                    // Get.back();
                                                  }
                                                },
                                              );
                                              // if (Get.find<AuthController>()
                                              //         .profileModel
                                              //         .active ==
                                              //     1) {
                                              //   Get.back();
                                              //   Get.find<OrderController>()
                                              //       .updateOrderStatus(controllerOrderModel.id,
                                              //           widget.orderIndex, 'picked_up',
                                              //           deliveryTime: time)
                                              //       .then((success) {
                                              //     if (success) {
                                              //       Get.find<AuthController>().getProfile();
                                              //       Get.find<OrderController>()
                                              //           .getCurrentOrders();
                                              //     }
                                              //   });
                                              // } else {
                                              //   showCustomSnackBar(
                                              //       'make_yourself_online_first'.tr);
                                              // }
                                            },
                                            onCancelled: () {
                                              Get.back();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    barrierDismissible: false),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircularCountDownTimer(
                              key: Key(orderController.latestOrderList[0].id
                                  .toString()),
                              duration: 55,
                              initialDuration: 0,
                              controller: controller,
                              width: MediaQuery.of(context).size.width / 14,
                              height: MediaQuery.of(context).size.height / 14,
                              ringColor: Colors.grey[300],
                              ringGradient: null,
                              fillColor: Theme.of(context).primaryColor,
                              fillGradient: null,
                              backgroundColor: Colors.white,
                              backgroundGradient: null,
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textStyle: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textFormat: CountdownTextFormat.SS,
                              isReverse: true,
                              isReverseAnimation: true,
                              isTimerTextShown: true,
                              autoStart: true,
                              onStart: () {
                                debugPrint('Countdown Started');

                                // print(widget.orderModel.id);
                                // print(initialDuration);
                              },
                              onComplete: () async {
                                _timer.cancel();
                                Get.back();
                              },
                              onChange: (String timeStamp) {
                                // debugPrint('Countdown Changed $timeStamp');
                              },
                            ),
                          ],
                        ),
                      ),

                      //   Image.asset(Images.notification_in,
                      //       height: 60, color: Theme.of(context).primaryColor),
                      //   Padding(
                      //     padding: EdgeInsets.only(
                      //         top: Dimensions.PADDING_SIZE_LARGE,
                      //         bottom: Dimensions.PADDING_SIZE_SMALL),
                      //   child: Text(
                      //     widget.isRequest
                      //         ? 'new_order_request_from_a_customer'.tr
                      //         : 'you_have_assigned_a_new_order'.tr,
                      //     textAlign: TextAlign.center,
                      //     style: robotoRegular.copyWith(
                      //         fontSize: Dimensions.FONT_SIZE_LARGE),
                      //   ),
                      // ),
                      //   orderController.orderDetailsModel != null
                      //       ? Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text('with'.tr,
                      //                 textAlign: TextAlign.center,
                      //                 style: robotoRegular.copyWith(
                      //                     fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      //             Text(
                      //               ' ${orderController.orderDetailsModel != null ? orderController.orderDetailsModel.length.toString() : 0} ',
                      //               textAlign: TextAlign.center,
                      //               style: robotoMedium.copyWith(
                      //                   fontSize: Dimensions.FONT_SIZE_LARGE),
                      //             ),
                      //             Text('items'.tr,
                      //                 textAlign: TextAlign.center,
                      //                 style: robotoRegular.copyWith(
                      //                     fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      //           ],
                      //         )
                      //       : SizedBox(),
                      //   orderController.orderDetailsModel != null
                      // ? ListView.builder(
                      //     itemCount: orderController.orderDetailsModel.length,
                      //     shrinkWrap: true,
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: Dimensions.PADDING_SIZE_SMALL),
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      //         child: Row(
                      //           children: [
                      //             Text('item'.tr + ' ${index + 1}: ',
                      //                 style: robotoMedium.copyWith(
                      //                     fontSize: Dimensions.FONT_SIZE_SMALL)),
                      //             Flexible(
                      //               child: Text(
                      //                   orderController.orderDetailsModel[index]
                      //                           .foodDetails.name +
                      //                       ' ( x ' +
                      //                       '${orderController.orderDetailsModel[index].quantity})',
                      //                   maxLines: 2,
                      //                   overflow: TextOverflow.ellipsis,
                      //                   style: robotoRegular.copyWith(
                      //                       fontSize:
                      //                           Dimensions.FONT_SIZE_SMALL)),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   )
                      //       : SizedBox(),
                      //   CustomButton(
                      //     height: 40,
                      //     buttonText: widget.isRequest
                      //         ? (Get.find<OrderController>().currentOrderList != null &&
                      //                 Get.find<OrderController>()
                      //                         .currentOrderList
                      //                         .length >
                      //                     0)
                      //             ? 'ok'.tr
                      //             : 'go'.tr
                      //         : 'ok'.tr,
                      //     onPressed: () {
                      //       if (!widget.isRequest) {
                      //         _timer?.cancel();
                      //       }
                      //       Get.back();
                      //       widget.onTap();
                      //     },
                      //   ),
                      // ],
                    ],
                  );
          },
        ),
      ),
    );
    // return Dialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
    //   //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
    //   child: Padding(
    //     padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
    //     child: Column(mainAxisSize: MainAxisSize.min, children: [
    //       Image.asset(Images.notification_in,
    //           height: 60, color: Theme.of(context).primaryColor),
    //       Padding(
    //         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
    //         child: Text(
    //           widget.isRequest
    //               ? 'new_order_request_from_a_customer'.tr
    //               : 'you_have_assigned_a_new_order'.tr,
    //           textAlign: TextAlign.center,
    //           style: robotoRegular.copyWith(
    //             fontSize: Dimensions.FONT_SIZE_LARGE,
    //           ),
    //         ),
    //       ),
    //       CustomButton(
    //         height: 40,
    //         buttonText: widget.isRequest
    //             ? (Get.find<OrderController>().currentOrderList != null &&
    //                     Get.find<OrderController>().currentOrderList.length > 0)
    //                 ? 'ok'.tr
    //                 : 'go'.tr
    //             : 'ok'.tr,
    //         onPressed: () {
    //           if (!widget.isRequest) {
    //             _timer?.cancel();
    //           }
    //           Get.back();
    //           widget.onTap();
    //         },
    //       ),
    //     ]),
    //   ),
    // );
  }
}
