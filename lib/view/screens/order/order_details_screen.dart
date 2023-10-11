import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/body/notification_body.dart';
import 'package:efood_multivendor_driver/data/model/response/conversation_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/info_card.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/verify_delivery_sheet.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool isRunningOrder;
  final int orderIndex;
  OrderDetailsScreen(
      {@required this.orderId,
      @required this.isRunningOrder,
      @required this.orderIndex});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int timeRemainingInSeconds;
  int totalDuration;
  int initialDuration;

  int deliveryTimeRemainingInSeconds;
  int deliveryTotalDuration;
  int deliveryInitialDuration;
  Timer _timer;

  void _startApiCalling() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      Get.find<OrderController>()
          .getOrderWithId(Get.find<OrderController>().orderModel.id);
    });
  }

  Future<void> _loadData() async {
    Get.find<OrderController>().getOrderWithId(widget.orderId);
    Get.find<OrderController>().getOrderDetails(widget.orderId);
  }

  @override
  void initState() {
    super.initState();

    _startApiCalling();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    
  }

  @override
  Widget build(BuildContext context) {
    CountDownController controller = CountDownController();
    bool _cancelPermission =
        Get.find<SplashController>().configModel.canceledByDeliveryman;
    bool _selfDelivery =
        Get.find<AuthController>().profileModel.type != 'zone_wise';

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        title: 'order_details'.tr,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<OrderController>(builder: (orderController) {
            OrderModel controllerOrderModel = orderController.orderModel;

            // int processing_time = controllerOrderModel.processingTime ?? null;

            // Calculate the initial duration based on order's start time and current time
            // You can implement this logic based on your requirements.

            //  _calculateInitialDuration();

            bool _restConfModel = Get.find<SplashController>()
                    .configModel
                    .orderConfirmationModel !=
                'deliveryman';

            bool _showBottomView;
            bool _showSlider;

            if (controllerOrderModel != null) {
              if (controllerOrderModel.processingTime != null) {
                totalDuration = controllerOrderModel.processingTime * 60;
              }

              if (controllerOrderModel.processingTime != null) {
                DateTime startTime =
                    DateTime.parse(controllerOrderModel.processing);

                DateTime currentTime = DateTime.now();
                // print(startTime);

                // if (controllerOrderModel.orderStatus == 'processing') {
                //   print(widget.orderModel.id);
                //   print(widget.orderModel.processingTime);
                // }

                timeRemainingInSeconds = startTime.isBefore(currentTime)
                    ? currentTime.difference(startTime).inSeconds
                    : 0;
              }

              if (controllerOrderModel.processingTime != null) {
                
                if (timeRemainingInSeconds <= totalDuration) {
                  initialDuration = timeRemainingInSeconds;
                 
                } else {
                  initialDuration = totalDuration;
                }
              }

             

              if (controllerOrderModel.deliveryTime != null) {

                if (controllerOrderModel.deliveryTime != null) {
                deliveryTotalDuration =
                    (int.parse(controllerOrderModel.deliveryTime) * 60) + totalDuration ;
              }
              print(deliveryInitialDuration.toString() + 'hello');

              if (controllerOrderModel.deliveryTime != null) {
                DateTime startTime =
                    DateTime.parse(controllerOrderModel.processing);

                DateTime currentTime = DateTime.now();

                // if (controllerOrderModel.orderStatus == 'processing') {
                //   print(widget.orderModel.id);
                //   print(widget.orderModel.processingTime);
                // }

                deliveryTimeRemainingInSeconds = startTime.isBefore(currentTime)
                    ? currentTime.difference(startTime).inSeconds
                    : 0;
              }

              if (controllerOrderModel.deliveryTime != null) {
                if (deliveryTimeRemainingInSeconds <= deliveryTotalDuration) {
                  deliveryInitialDuration = deliveryTimeRemainingInSeconds;
                } else {
                  deliveryInitialDuration = deliveryTotalDuration;
                }
              }
              // print(deliveryInitialDuration);
              // print(deliveryTotalDuration);
                
              }
              _showBottomView =
                  controllerOrderModel.orderStatus == 'accepted' ||
                      controllerOrderModel.orderStatus == 'confirmed' ||
                      controllerOrderModel.orderStatus == 'processing' ||
                      controllerOrderModel.orderStatus == 'handover' ||
                      controllerOrderModel.orderStatus == 'picked_up' ||
                      (widget.isRunningOrder ?? true);
              _showSlider =
                  (controllerOrderModel.paymentMethod == 'cash_on_delivery' &&
                          controllerOrderModel.orderStatus == 'accepted' &&
                          !_restConfModel &&
                          !_selfDelivery) ||
                      controllerOrderModel.orderStatus == 'handover' ||
                      controllerOrderModel.orderStatus == 'picked_up';
            }

            // Get.find<OrderController>().initCheckValues();
            // if(orderController.orderDetailsModel != null){
            //   for (var foodItem in orderController.orderDetailsModel) {

            //     if (foodItem.isChecked == 1) {
            //       orderController.isCheckedValues.add(foodItem.foodId);

            //     }

            //   }
            // }

            print(orderController.isCheckedValues);

            return (orderController.orderDetailsModel != null &&
                    controllerOrderModel != null)
                ? Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(children: [
                        DateConverter.isBeforeTime(
                          controllerOrderModel.scheduleAt,
                        )
                            ? (controllerOrderModel.orderStatus !=
                                        'delivered' &&
                                    controllerOrderModel.orderStatus !=
                                        'failed' &&
                                    controllerOrderModel.orderStatus !=
                                        'canceled')
                                ? Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        child: Image.asset(
                                          Images.animate_delivery_man,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),
                                      Text('Food will cook within:'.tr,
                                          style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                          )),
                                      SizedBox(
                                        height:
                                            Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      Center(
                                        child: controllerOrderModel
                                                    .processingTime !=
                                                null
                                            ? CircularCountdown(
                                                orderKey: controllerOrderModel
                                                    .id
                                                    .toString(),
                                                controller: controller,
                                                totalDuration: totalDuration,
                                                initialDuration:
                                                    initialDuration)
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    // Text(
                                                    //   DateConverter.differenceInMinute(
                                                    //               controllerOrderModel
                                                    //                   .restaurantDeliveryTime,
                                                    //               controllerOrderModel
                                                    //                   .createdAt,
                                                    //               controllerOrderModel
                                                    //                   .processingTime,
                                                    //               controllerOrderModel
                                                    //                   .scheduleAt) <
                                                    //           5
                                                    //       ? '1 - 5'
                                                    //       : '${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt) - 5} '
                                                    //           '- ${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt)}',
                                                    //   style: robotoBold.copyWith(
                                                    //     fontSize: Dimensions
                                                    //         .FONT_SIZE_EXTRA_LARGE,
                                                    //   ),
                                                    // ),

                                                    Text(
                                                      '---',
                                                      style:
                                                          robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_EXTRA_LARGE,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL,
                                                    ),
                                                    Text('min'.tr,
                                                        style: robotoMedium
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .FONT_SIZE_LARGE,
                                                                color: Theme.of(
                                                                  context,
                                                                ).primaryColor)),
                                                  ]),
                                      ),
                                      SizedBox(
                                        height:
                                            Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                      ),
                                      Text('Food will deliver within:'.tr,
                                          style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                          )),
                                      SizedBox(
                                        height:
                                            Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      Center(
                                        child: controllerOrderModel
                                                    .deliveryTime !=
                                                null
                                            ? CircularCountdown(
                                                orderKey: controllerOrderModel
                                                    .id
                                                    .toString(),
                                                controller: controller,
                                                totalDuration: deliveryTotalDuration,
                                                initialDuration:
                                                    deliveryInitialDuration)
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    // Text(
                                                    //   DateConverter.differenceInMinute(
                                                    //               controllerOrderModel
                                                    //                   .restaurantDeliveryTime,
                                                    //               controllerOrderModel
                                                    //                   .createdAt,
                                                    //               controllerOrderModel
                                                    //                   .processingTime,
                                                    //               controllerOrderModel
                                                    //                   .scheduleAt) <
                                                    //           5
                                                    //       ? '1 - 5'
                                                    //       : '${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt) - 5} '
                                                    //           '- ${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt)}',
                                                    //   style: robotoBold.copyWith(
                                                    //     fontSize: Dimensions
                                                    //         .FONT_SIZE_EXTRA_LARGE,
                                                    //   ),
                                                    // ),

                                                    Text(
                                                      '---',
                                                      style:
                                                          robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_EXTRA_LARGE,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL,
                                                    ),
                                                    Text('min'.tr,
                                                        style: robotoMedium
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .FONT_SIZE_LARGE,
                                                                color: Theme.of(
                                                                  context,
                                                                ).primaryColor)),
                                                  ]),
                                      ),
                                    ],
                                  )
                                : SizedBox()
                            : SizedBox(),
                        Row(children: [
                          Text(
                            '${'order_id'.tr}:',
                            style: robotoRegular,
                          ),
                          SizedBox(
                            width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          Text(controllerOrderModel.id.toString(),
                              style: robotoMedium),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Expanded(child: SizedBox()),
                          Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green)),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(
                            controllerOrderModel.orderStatus.tr ?? '',
                            style: robotoRegular,
                          ),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        InfoCard(
                          title: 'restaurant_details'.tr,
                          addressModel: DeliveryAddress(
                              address: controllerOrderModel.restaurantAddress),
                          image:
                              '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${controllerOrderModel.restaurantLogo}',
                          name: controllerOrderModel.restaurantName,
                          phone: controllerOrderModel.restaurantPhone,
                          latitude: controllerOrderModel.restaurantLat,
                          longitude: controllerOrderModel.restaurantLng,
                          showButton: (controllerOrderModel.orderStatus !=
                                  'delivered' &&
                              controllerOrderModel.orderStatus != 'failed' &&
                              controllerOrderModel.orderStatus != 'canceled'),
                          orderModel: controllerOrderModel,
                          messageOnTap: () async {
                            _timer?.cancel();
                            await Get.toNamed(RouteHelper.getChatRoute(
                              notificationBody: NotificationBody(
                                orderId: controllerOrderModel.id,
                                vendorId: controllerOrderModel.vendorId,
                              ),
                              user: User(
                                id: controllerOrderModel.vendorId,
                                fName: controllerOrderModel.restaurantName,
                                image: controllerOrderModel.restaurantLogo,
                              ),
                            ));
                            _startApiCalling();
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        InfoCard(
                          title: 'customer_contact_details'.tr,
                          addressModel: controllerOrderModel.deliveryAddress,
                          isDelivery: true,
                          image: controllerOrderModel.customer != null
                              ? '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${controllerOrderModel.customer.image}'
                              : '',
                          name: controllerOrderModel
                              .deliveryAddress.contactPersonName,
                          phone: controllerOrderModel
                              .deliveryAddress.contactPersonNumber,
                          latitude:
                              controllerOrderModel.deliveryAddress.latitude,
                          longitude:
                              controllerOrderModel.deliveryAddress.longitude,
                          showButton: (controllerOrderModel.orderStatus !=
                                  'delivered' &&
                              controllerOrderModel.orderStatus != 'failed' &&
                              controllerOrderModel.orderStatus != 'canceled'),
                          orderModel: controllerOrderModel,
                          messageOnTap: () async {
                            if (controllerOrderModel.customer != null) {
                              _timer?.cancel();
                              await Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBody(
                                  orderId: controllerOrderModel.id,
                                  customerId: controllerOrderModel.customer.id,
                                ),
                                user: User(
                                  id: controllerOrderModel.customer.id,
                                  fName: controllerOrderModel.customer.fName,
                                  lName: controllerOrderModel.customer.lName,
                                  image: controllerOrderModel.customer.image,
                                ),
                              ));
                              _startApiCalling();
                            } else {
                              showCustomSnackBar('${'customer_not_found'.tr}');
                            }
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Row(children: [
                                  Text('${'item'.tr}:', style: robotoRegular),
                                  SizedBox(
                                      width:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    orderController.orderDetailsModel.length
                                        .toString(),
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL,
                                        vertical: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      controllerOrderModel.paymentMethod ==
                                              'cash_on_delivery'
                                          ? 'cod'.tr
                                          : controllerOrderModel
                                                      .paymentMethod ==
                                                  'wallet'
                                              ? 'wallet_payment'.tr
                                              : 'digitally_paid'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color: Theme.of(context).cardColor),
                                    ),
                                  ),
                                ]),
                              ),
                              Divider(height: Dimensions.PADDING_SIZE_LARGE),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    orderController.orderDetailsModel.length,
                                itemBuilder: (context, index) {
                                  OrderDetailsModel item =
                                      orderController.orderDetailsModel[index];
                                  // print(item.foodId);

                                  // print(orderController.isCheckedValues);
                                  // print('Hello World');

                                  return OrderProductWidget(
                                      order: controllerOrderModel,
                                      orderDetails: orderController
                                          .orderDetailsModel[index],
                                      onChanged: (bool) {
                                        orderController.addCheck(
                                          item.orderId,
                                          item.foodId,
                                          bool == false ? 0 : 1,
                                        );
                                      },
                                      // value: ischecked ?? false,
                                      // value: item.isChecked == 0 ? false : true,
                                      value: orderController.isCheckedValues
                                          .contains(item.foodId));
                                },
                              ),
                              (controllerOrderModel.orderNote != null &&
                                      controllerOrderModel.orderNote.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text('additional_note'.tr,
                                              style: robotoRegular),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Container(
                                            width: 1170,
                                            padding: EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                            child: Text(
                                              controllerOrderModel.orderNote,
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                        ])
                                  : SizedBox(),
                            ]),
                      ]),
                    )),
                    _showBottomView
                        ? ((controllerOrderModel.orderStatus == 'accepted' &&
                                    (controllerOrderModel.paymentMethod !=
                                            'cash_on_delivery' ||
                                        _restConfModel ||
                                        _selfDelivery)) ||
                                controllerOrderModel.orderStatus ==
                                    'processing' ||
                                controllerOrderModel.orderStatus == 'confirmed')
                            ? Container(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  border: Border.all(width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controllerOrderModel.orderStatus ==
                                          'processing'
                                      ? 'food_is_preparing'.tr
                                      : 'food_waiting_for_cook'.tr,
                                  style: robotoMedium,
                                ),
                              )
                            : _showSlider
                                ? (controllerOrderModel.paymentMethod ==
                                            'cash_on_delivery' &&
                                        controllerOrderModel.orderStatus ==
                                            'accepted' &&
                                        !_restConfModel &&
                                        _cancelPermission &&
                                        !_selfDelivery)
                                    ? Row(children: [
                                        Expanded(
                                            child: TextButton(
                                          onPressed: () => Get.dialog(
                                              ConfirmationDialog(
                                                icon: Images.warning,
                                                title:
                                                    'are_you_sure_to_cancel'.tr,
                                                description:
                                                    'you_want_to_cancel_this_order'
                                                        .tr,
                                                onYesPressed: () {
                                                  orderController
                                                      .updateOrderStatus(
                                                          controllerOrderModel
                                                              .id,
                                                          widget.orderIndex,
                                                          'canceled',
                                                          back: true)
                                                      .then((success) {
                                                    if (success) {
                                                      Get.find<AuthController>()
                                                          .getProfile();
                                                      Get.find<
                                                              OrderController>()
                                                          .getCurrentOrders();
                                                    }
                                                  });
                                                },
                                              ),
                                              barrierDismissible: false),
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(1170, 40),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .color),
                                            ),
                                          ),
                                          child: Text('cancel'.tr,
                                              textAlign: TextAlign.center,
                                              style: robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color,
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                              )),
                                        )),
                                        SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        Expanded(
                                            child: CustomButton(
                                          buttonText: 'confirm'.tr,
                                          height: 40,
                                          onPressed: () {
                                            Get.dialog(
                                                ConfirmationDialog(
                                                  icon: Images.warning,
                                                  title:
                                                      'are_you_sure_to_confirm'
                                                          .tr,
                                                  description:
                                                      'you_want_to_confirm_this_order'
                                                          .tr,
                                                  onYesPressed: () {
                                                    orderController
                                                        .updateOrderStatus(
                                                            controllerOrderModel
                                                                .id,
                                                            widget.orderIndex,
                                                            'confirmed',
                                                            back: true)
                                                        .then((success) {
                                                      if (success) {
                                                        Get.find<
                                                                AuthController>()
                                                            .getProfile();
                                                        Get.find<
                                                                OrderController>()
                                                            .getCurrentOrders();
                                                      }
                                                    });
                                                  },
                                                ),
                                                barrierDismissible: false);
                                          },
                                        )),
                                      ])
                                    : GetBuilder<OrderController>(
                                        builder: (con) {
                                        return con.isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (controllerOrderModel
                                                                .paymentMethod ==
                                                            'cash_on_delivery' &&
                                                        controllerOrderModel
                                                                .orderStatus ==
                                                            'accepted' &&
                                                        !_restConfModel &&
                                                        !_selfDelivery) {
                                                      Get.dialog(
                                                          ConfirmationDialog(
                                                            icon:
                                                                Images.warning,
                                                            title:
                                                                'are_you_sure_to_confirm'
                                                                    .tr,
                                                            description:
                                                                'you_want_to_confirm_this_order'
                                                                    .tr,
                                                            onYesPressed: () {
                                                              orderController
                                                                  .updateOrderStatus(
                                                                      controllerOrderModel
                                                                          .id,
                                                                      widget
                                                                          .orderIndex,
                                                                      'confirmed',
                                                                      back:
                                                                          true)
                                                                  .then(
                                                                      (success) {
                                                                if (success) {
                                                                  Get.find<
                                                                          AuthController>()
                                                                      .getProfile();
                                                                  Get.find<
                                                                          OrderController>()
                                                                      .getCurrentOrders();
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          barrierDismissible:
                                                              false);
                                                    } else if (controllerOrderModel
                                                            .orderStatus ==
                                                        'picked_up') {
                                                      if (Get.find<
                                                                  SplashController>()
                                                              .configModel
                                                              .orderDeliveryVerification ||
                                                          controllerOrderModel
                                                                  .paymentMethod ==
                                                              'cash_on_delivery') {
                                                        Get.bottomSheet(
                                                            VerifyDeliverySheet(
                                                              orderIndex: widget
                                                                  .orderIndex,
                                                              verify: Get.find<
                                                                      SplashController>()
                                                                  .configModel
                                                                  .orderDeliveryVerification,
                                                              orderAmount:
                                                                  controllerOrderModel
                                                                      .orderAmount,
                                                              cod: controllerOrderModel
                                                                      .paymentMethod ==
                                                                  'cash_on_delivery',
                                                            ),
                                                            isScrollControlled:
                                                                true);
                                                      } else {
                                                        Get.find<
                                                                OrderController>()
                                                            .updateOrderStatus(
                                                                controllerOrderModel
                                                                    .id,
                                                                widget
                                                                    .orderIndex,
                                                                'delivered')
                                                            .then((success) {
                                                          if (success) {
                                                            Get.find<
                                                                    AuthController>()
                                                                .getProfile();
                                                            Get.find<
                                                                    OrderController>()
                                                                .getCurrentOrders();
                                                          }
                                                        });
                                                      }
                                                    } else if (controllerOrderModel
                                                            .orderStatus ==
                                                        'handover') {
                                                      if (Get.find<
                                                                  AuthController>()
                                                              .profileModel
                                                              .active ==
                                                          1) {
                                                        Get.find<
                                                                OrderController>()
                                                            .updateOrderStatus(
                                                                controllerOrderModel
                                                                    .id,
                                                                widget
                                                                    .orderIndex,
                                                                'picked_up')
                                                            .then((success) {
                                                          if (success) {
                                                            Get.find<
                                                                    AuthController>()
                                                                .getProfile();
                                                            Get.find<
                                                                    OrderController>()
                                                                .getCurrentOrders();
                                                          }
                                                        });
                                                      } else {
                                                        showCustomSnackBar(
                                                            'make_yourself_online_first'
                                                                .tr);
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    (controllerOrderModel
                                                                    .paymentMethod ==
                                                                'cash_on_delivery' &&
                                                            controllerOrderModel
                                                                    .orderStatus ==
                                                                'accepted' &&
                                                            !_restConfModel &&
                                                            !_selfDelivery)
                                                        ? 'swipe_to_confirm_order'
                                                            .tr
                                                        : controllerOrderModel
                                                                    .orderStatus ==
                                                                'picked_up'
                                                            ? 'swipe_to_deliver_order'
                                                                .tr
                                                            : controllerOrderModel
                                                                        .orderStatus ==
                                                                    'handover'
                                                                ? 'swipe_to_pick_up_order'
                                                                    .tr
                                                                : '',
                                                    style: robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE,
                                                        color:
                                                            Color(0xffF4F7FC)),
                                                  ),

                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // backgroundColor: Color(0xffF4F7FC),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    // side: BorderSide(color: Colors.yellow, width: 5),
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                    fixedSize: Size(1170, 60),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),

                                                    shadowColor:
                                                        Colors.lightBlue,
                                                    elevation: 0,
                                                  ),
                                                  // dismissThresholds: 0.5,
                                                  // dismissible: false,
                                                  // shimmer: true,
                                                  // width: 1170,
                                                  // height: 60,
                                                  // buttonSize: 50,
                                                  // radius: 10,
                                                  // icon: Center(
                                                  //     child: Icon(
                                                  //   Get.find<LocalizationController>()
                                                  //           .isLtr
                                                  //       ? Icons.double_arrow_sharp
                                                  //       : Icons.keyboard_arrow_left,
                                                  //   color: Colors.white,
                                                  //   size: 20.0,
                                                  // )),
                                                  // isLtr:
                                                  //     Get.find<LocalizationController>()
                                                  //         .isLtr,
                                                  // boxShadow: BoxShadow(blurRadius: 0),
                                                  // buttonColor:
                                                  //     Theme.of(context).primaryColor,
                                                  // backgroundColor: Color(0xffF4F7FC),
                                                  // baseColor:
                                                  //     Theme.of(context).primaryColor,
                                                ),
                                                // child: SliderButton(

                                                // label: Text(
                                                //   (controllerOrderModel
                                                //                   .paymentMethod ==
                                                //               'cash_on_delivery' &&
                                                //           controllerOrderModel
                                                //                   .orderStatus ==
                                                //               'accepted' &&
                                                //           !_restConfModel &&
                                                //           !_selfDelivery)
                                                //       ? 'swipe_to_confirm_order'
                                                //           .tr
                                                //       : controllerOrderModel
                                                //                   .orderStatus ==
                                                //               'picked_up'
                                                //           ? 'swipe_to_deliver_order'
                                                //               .tr
                                                //           : controllerOrderModel
                                                //                       .orderStatus ==
                                                //                   'handover'
                                                //               ? 'swipe_to_pick_up_order'
                                                //                   .tr
                                                //               : '',
                                                //   style: robotoMedium.copyWith(
                                                //       fontSize: Dimensions
                                                //           .FONT_SIZE_LARGE,
                                                //       color: Theme.of(context)
                                                //           .primaryColor),
                                                // ),
                                                //   dismissThresholds: 0.5,
                                                //   dismissible: false,
                                                //   shimmer: true,
                                                //   width: 1170,
                                                //   height: 60,
                                                //   buttonSize: 50,
                                                //   radius: 10,
                                                //   icon: Center(
                                                //       child: Icon(
                                                //     Get.find<LocalizationController>()
                                                //             .isLtr
                                                //         ? Icons
                                                //             .double_arrow_sharp
                                                //         : Icons
                                                //             .keyboard_arrow_left,
                                                //     color: Colors.white,
                                                //     size: 20.0,
                                                //   )),
                                                //   isLtr: Get.find<
                                                //           LocalizationController>()
                                                //       .isLtr,
                                                //   boxShadow:
                                                //       BoxShadow(blurRadius: 0),
                                                //   buttonColor: Theme.of(context)
                                                //       .primaryColor,
                                                //   backgroundColor:
                                                //       Color(0xffF4F7FC),
                                                //   baseColor: Theme.of(context)
                                                //       .primaryColor,
                                                // ),
                                              );
                                      })
                                : SizedBox()
                        : SizedBox(),
                  ])
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}

class CircularCountdown extends StatefulWidget {
  CircularCountdown({
    Key key,
    @required this.totalDuration,
    @required this.initialDuration,
    @required this.controller,
    @required this.orderKey,
  }) : super(key: key);
  String orderKey;
  CountDownController controller;
  final int totalDuration;
  final int initialDuration;

  @override
  State<CircularCountdown> createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      key: Key(widget.orderKey),
      duration: widget.totalDuration,
      initialDuration: widget.initialDuration,
      controller: widget.controller,
      width: MediaQuery.of(context).size.height / 14,
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
          fontSize: 19.0,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.MM_SS,
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
        // Future.delayed(Duration.zero, () {
        //   Get.dialog(
        //     ProcessingTimeDialog(),
        //     barrierColor: Colors.transparent,
        //   );
        // });
      },
      onChange: (String timeStamp) {
        // debugPrint('Countdown Changed $timeStamp');
      },
    );
  }
}
