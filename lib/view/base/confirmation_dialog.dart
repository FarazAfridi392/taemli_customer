import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final double iconSize;
  final String title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final bool hasCancel;
  final bool pop;
  ConfirmationDialog({
    @required this.icon,
    this.iconSize = 50,
    this.title,
    @required this.description,
    @required this.onYesPressed,
    this.isLogOut = false,
    this.pop = false,
    this.hasCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Image.asset(icon, width: iconSize, height: iconSize),
          ),
          title != null
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                        color: Colors.red),
                  ),
                )
              : SizedBox(),
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Text(description,
                style:
                    robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                textAlign: TextAlign.center),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          GetBuilder<OrderController>(builder: (orderController) {
            return orderController.isLoading
                ? CircularProgressIndicator()
                : Row(children: [
                    hasCancel
                        ? Expanded(
                            child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextButton(
                              onPressed: () => isLogOut
                                  ? onYesPressed()
                                  : pop
                                      ? Navigator.pop(context)
                                      : Get.back(),
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.3),
                                minimumSize: Size(1170, 40),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL)),
                              ),
                              child: Text(
                                isLogOut ? 'yes'.tr : 'no'.tr,
                                textAlign: TextAlign.center,
                                style: robotoBold.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
                              ),
                            ),
                          ))
                        : SizedBox(),
                    SizedBox(
                        width: hasCancel ? Dimensions.PADDING_SIZE_LARGE : 0),
                    Expanded(
                        child: CustomButton(
                      buttonText: isLogOut
                          ? 'no'.tr
                          : hasCancel
                              ? 'yes'.tr
                              : 'ok'.tr,
                      onPressed: () => isLogOut
                          ? pop
                              ? Navigator.pop(context)
                              : Get.back()
                          : onYesPressed(),
                      height: 40,
                    )),
                  ]);
          }),
        ]),
      ),
    );
  }
}
