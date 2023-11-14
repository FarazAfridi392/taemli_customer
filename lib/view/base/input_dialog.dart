import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/custom_text_field.dart';
import 'package:efood_multivendor_driver/view/base/time_option_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputDialog extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final Function(String value) onPressed;
  final Function onCancelled;
  InputDialog({
    @required this.icon,
    this.title,
    @required this.description,
    @required this.onPressed,
    @required this.onCancelled,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  int selectedTime = 0; // Default selection

  void _selectTime(int time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
          width: 500,
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Image.asset(widget.icon, width: 50, height: 50),
                ),
                widget.title != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              color: Colors.red),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Text(widget.description,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TimeOptionButton(
                            time: 5,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                          TimeOptionButton(
                            time: 7,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                          TimeOptionButton(
                            time: 10,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TimeOptionButton(
                            time: 15,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                          TimeOptionButton(
                            time: 20,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                          TimeOptionButton(
                            time: 25,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TimeOptionButton(
                            time: 40,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                          TimeOptionButton(
                            time: 50,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                          TimeOptionButton(
                            time: 65,
                            selectedTime: selectedTime,
                            onSelectTime: _selectTime,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             AnotherWidget(selectedTime: selectedTime),
                      //       ),
                      //     );
                      //   },
                      //   child: Text('Continue'),
                      // ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).disabledColor),
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                  child: CustomTextField(
                    maxLines: 1,
                    controller: _textEditingController,
                    hintText: 'Enter Delivery Time in Minutes',
                    isEnabled: true,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.done,
                    onChanged: (string) {
                      if (string.isNotEmpty) {
                        _selectTime(int.parse(string));
                      } else {
                        _selectTime(0);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('selected_time'.tr + ': $selectedTime ' + 'min'.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                GetBuilder<OrderController>(
                  builder: (orderController) {
                    return Row(
                      children: [
                        Expanded(
                            child: CustomButton(
                          buttonText: 'submit'.tr,
                          height: 40,
                          onPressed: () {
                            if (selectedTime == 0) {
                              showCustomSnackBar(
                                  'Enter Delivery Time in Minutes');
                            } else {
                              widget.onPressed(selectedTime.toString());
                            }
                          },
                        )),
                        SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                        Expanded(
                          child: TextButton(
                            onPressed: () => widget.onCancelled(),
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
                              'cancel'.tr,
                              textAlign: TextAlign.center,
                              style: robotoBold.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ]),
            ),
          )),
    );
  }

  String reverseString(String text) {
    text = text.splitMapJoin(
      RegExp(r'[\u0590-\u05FF]+'),
      onMatch: (m) => m.group(0).split('').reversed.join(),
      onNonMatch: (string) => string,
    );
    // reverse words in string
    return text.split(' ').reversed.join(' ');
  }
}
