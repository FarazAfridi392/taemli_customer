import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  final int orderIndex;
  OrderWidget(
      {@required this.orderModel,
      @required this.isRunningOrder,
      @required this.orderIndex});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[Get.isDarkMode ? 800 : 200],
              blurRadius: 5,
              spreadRadius: 1)
        ],
      ),
      child: Column(children: [
        Row(children: [
          Text('${'order_id'.tr}:',
              style:
                  robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.bold)),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text('#${orderModel.id}',
              style:
                  robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.bold)),
          Expanded(child: SizedBox()),
          Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: orderModel.paymentMethod == 'cash_on_delivery'
                    ? Colors.red
                    : Colors.green,
                shape: BoxShape.circle,
              )),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(
            orderModel.paymentMethod == 'cash_on_delivery'
                ? 'cod'.tr
                : 'digitally_paid'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.bold),
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                  orderModel.orderStatus == 'picked_up'
                      ? Images.user
                      : Images.house,
                  width: 25,
                  height: 18),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                orderModel.orderStatus == 'picked_up'
                    ? 'customer_location'.tr
                    : 'restaurant_location'.tr,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 25),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Expanded(
                  child: Text(
                orderModel.orderStatus == 'picked_up'
                    ? orderModel.deliveryAddress.address.toString()
                    : orderModel.restaurantAddress ?? '',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ]),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        Row(children: [
          Expanded(
              child: TextButton(
            onPressed: () {
              Get.toNamed(
                RouteHelper.getOrderDetailsRoute(orderModel.id),
                arguments: OrderDetailsScreen(
                    orderId: orderModel.id,
                    isRunningOrder: isRunningOrder,
                    orderIndex: orderIndex),
              );
            },
            style: TextButton.styleFrom(
                minimumSize: Size(1170, 45),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  side: BorderSide(
                      width: 2, color: Theme.of(context).disabledColor),
                )),
            child: Text('details'.tr,
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
          )),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
              child: CustomButton(
            action: false,
            height: 45,
            onPressed: () async {
              Get.dialog(Dialog(
                alignment: Alignment.center,
                backgroundColor: Colors.white,
                elevation: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        'Choose App to Navigate',
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).primaryColor),
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              String _url;
                              if (orderModel.orderStatus == 'picked_up') {
                                _url =
                                    'https://waze.com/ul?ll=${orderModel.deliveryAddress.latitude},${orderModel.deliveryAddress.longitude}&navigate=yes';
                                // 'https://www.google.com/maps/dir/?api=1&destination=${orderModel.deliveryAddress.latitude}'
                                // ',${orderModel.deliveryAddress.longitude}&mode=d';
                              } else {
                                _url = _url =
                                    'https://waze.com/ul?ll=${orderModel.restaurantLat},${orderModel.restaurantLng}&navigate=yes';
                              }
                              // String url =
                              //     'https://waze.com/ul?ll=${latitude},${longitude}&navigate=yes';
                              // String url ='https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&mode=d';
                              if (await canLaunchUrlString(_url)) {
                                await launchUrlString(_url,
                                    mode: LaunchMode.externalApplication);
                                Get.back();
                              } else {
                                throw '${'could_not_launch'.tr} $_url';
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/image/waze.png',
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Waze',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              String _url;
                              if (orderModel.orderStatus == 'picked_up') {
                                _url =
                                    'https://www.google.com/maps/dir/?api=1&destination=${orderModel.deliveryAddress.latitude}'
                                    ',${orderModel.deliveryAddress.longitude}&mode=d';
                              } else {
                                _url =
                                    'https://www.google.com/maps/dir/?api=1&destination=${orderModel.restaurantLat ?? '0'}'
                                    ',${orderModel.restaurantLng ?? '0'}&mode=d';
                              }
                              if (await canLaunchUrlString(_url)) {
                                await launchUrlString(_url,
                                    mode: LaunchMode.externalApplication);
                                Get.back();
                              } else {
                                throw '${'could_not_launch'.tr} $_url';
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/image/google_map.png',
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'G-Maps',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                ),
              ));

              // String _url;
              // if (orderModel.orderStatus == 'picked_up') {
              //   _url =
              //       'https://www.google.com/maps/dir/?api=1&destination=${orderModel.deliveryAddress.latitude}'
              //       ',${orderModel.deliveryAddress.longitude}&mode=d';
              // } else {
              //   _url =
              //       'https://www.google.com/maps/dir/?api=1&destination=${orderModel.restaurantLat ?? '0'}'
              //       ',${orderModel.restaurantLng ?? '0'}&mode=d';
              // }
              // if (await canLaunchUrlString(_url)) {
              //   await launchUrlString(_url,
              //       mode: LaunchMode.externalApplication);
              // } else {
              //   showCustomSnackBar('${'could_not_launch'.tr} $_url');
              // }
            },
            buttonText: 'direction'.tr,
            icon: Icons.directions,
          )),
        ]),
      ]),
    );
  }
}
