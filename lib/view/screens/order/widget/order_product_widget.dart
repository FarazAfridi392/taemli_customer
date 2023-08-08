import 'package:efood_multivendor_driver/controller/checkbox_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OrderProductWidget extends StatefulWidget {
  final OrderModel order;
  final OrderDetailsModel orderDetails;
  final bool value;
  void Function(bool) onChanged;
  // bool value;

  OrderProductWidget({
    @required this.order,
    @required this.orderDetails,
    @required this.value,
    @required this.onChanged,
  });

  @override
  State<OrderProductWidget> createState() => _OrderProductWidgetState();
}

class _OrderProductWidgetState extends State<OrderProductWidget> {
  final CheckboxController controller = Get.put(CheckboxController());

  @override
  Widget build(BuildContext context) {
    String _addOnText = '';
    widget.orderDetails.addOns.forEach((addOn) {
      _addOnText = _addOnText +
          '${(_addOnText.isEmpty) ? '' : ''}\n${addOn.name} x${addOn.quantity}';
    });

    String _variationText = '';
    if (widget.orderDetails.variation.length > 0) {
      List<String> _variationTypes = widget.orderDetails.variation[0].type.split('-');
      if (_variationTypes.length ==
          widget.orderDetails.foodDetails.choiceOptions.length) {
        int _index = 0;
        widget.orderDetails.foodDetails.choiceOptions.forEach((choice) {
          _variationText = _variationText + '${(_index == 0) ? '' : ''}\n${_variationTypes[_index]}';
              // '${(_index == 0) ? '' : ',  '}\n${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      } else {
        _variationText = widget.orderDetails.foodDetails.variations[0].type;
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
          activeColor: Theme.of(context).primaryColor,
          side: BorderSide(color: Colors.black),

        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            image:
                '${widget.orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/'
                '${widget.orderDetails.foodDetails.image}',
            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                height: 50, width: 50, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(
                widget.orderDetails.foodDetails.name,
                style:
                    robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
              Text('${'quantity'.tr}:',
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL)),
              Text(
                widget.orderDetails.quantity.toString(),
                style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.FONT_SIZE_SMALL),
              ),
            ]),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Row(children: [
              Text(
                PriceConverter.convertPrice(
                    widget.orderDetails.price - widget.orderDetails.discountOnFood),
                style: robotoMedium,
              ),
              SizedBox(width: 5),
              widget.orderDetails.discountOnFood > 0
                  ? Expanded(
                      child: Text(
                      PriceConverter.convertPrice(widget.orderDetails.price),
                      style: robotoMedium.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: Theme.of(context).disabledColor,
                      ),
                    ))
                  : Expanded(child: SizedBox()),
              Get.find<SplashController>().configModel.toggleVegNonVeg
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        widget.orderDetails.foodDetails.veg == 0
                            ? 'non_veg'.tr
                            : 'veg'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            color: Colors.white),
                      ),
                    )
                  : SizedBox(),
            ]),
          ]),
        ),
      ]),
      _addOnText.isNotEmpty
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${'addons'.tr}: ',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL)),
                          Text(_addOnText,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Theme.of(context).disabledColor,
                              )),
                        ]),
                  ),
                ],
              )
            : SizedBox(),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        widget.orderDetails.foodDetails.variations.length > 0
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${'variations'.tr}: ',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL)),
                          Text(_variationText,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Theme.of(context).disabledColor,
                              )),
                        ]),
                  ),
                ],
              )
            : SizedBox(),
      Divider(height: Dimensions.PADDING_SIZE_LARGE),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
    ]);
  }
}
