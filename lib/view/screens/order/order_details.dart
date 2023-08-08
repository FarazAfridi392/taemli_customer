import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/body/notification_body.dart';
import 'package:efood_multivendor_driver/data/model/response/conversation_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen1 extends StatelessWidget {
  final OrderModel order;
  OrderDetailsScreen1({@required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(title: 'order_details'.tr),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [
                Row(children: [
                  Text('${'order_id'.tr}:', style: robotoRegular),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(order.id.toString(), style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Expanded(child: SizedBox()),
                  Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    order.orderStatus.tr ?? '',
                    style: robotoRegular,
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Row(children: [
                  Text('${'item'.tr}:', style: robotoRegular),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    order.detailsCount.toString(),
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      order.paymentMethod == 'cash_on_delivery'
                          ? 'cod'.tr
                          : order.paymentMethod == 'wallet'
                              ? 'wallet_payment'.tr
                              : 'digitally_paid'.tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          color: Theme.of(context).cardColor),
                    ),
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                InfoCard(
                  title: 'restaurant_details'.tr,
                  addressModel:
                      DeliveryAddress(address: order.restaurantAddress),
                  image:
                      '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${order.restaurantLogo}',
                  name: order.restaurantName,
                  phone: order.restaurantPhone,
                  latitude: order.restaurantLat,
                  longitude: order.restaurantLng,
                  showButton: (order.orderStatus != 'delivered' &&
                      order.orderStatus != 'failed' &&
                      order.orderStatus != 'canceled'),
                  orderModel: order,
                  messageOnTap: () async {
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBody(
                        orderId: order.id,
                        vendorId: order.vendorId,
                      ),
                      user: User(
                        id: order.vendorId,
                        fName: order.restaurantName,
                        image: order.restaurantLogo,
                      ),
                    ));
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                InfoCard(
                  title: 'customer_contact_details'.tr,
                  addressModel: order.deliveryAddress,
                  isDelivery: true,
                  image: order.customer != null
                      ? '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${order.customer.image}'
                      : '',
                  name: order.deliveryAddress.contactPersonName,
                  phone: order.deliveryAddress.contactPersonNumber,
                  latitude: order.deliveryAddress.latitude,
                  longitude: order.deliveryAddress.longitude,
                  showButton: (order.orderStatus != 'delivered' &&
                      order.orderStatus != 'failed' &&
                      order.orderStatus != 'canceled'),
                  orderModel: order,
                  messageOnTap: () async {
                    if (order.customer != null) {
                      await Get.toNamed(RouteHelper.getChatRoute(
                        notificationBody: NotificationBody(
                          orderId: order.id,
                          customerId: order.customer.id,
                        ),
                        user: User(
                          id: order.customer.id,
                          fName: order.customer.fName,
                          lName: order.customer.lName,
                          image: order.customer.image,
                        ),
                      ));
                    } else {
                      showCustomSnackBar('${'customer_not_found'.tr}');
                    }
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  ),
                ]),
              ]),
            )),
          ]),
        ),
      ),
    );
  }
}
