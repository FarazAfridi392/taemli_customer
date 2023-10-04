import 'package:efood_multivendor_driver/util/dimensions.dart';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../util/styles.dart';
class TimeOptionButton extends StatelessWidget {
  final int time;
  final int selectedTime;
  final Function(int) onSelectTime;

  TimeOptionButton({
    @required this.time,
    @required this.selectedTime,
    @required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectTime(time);
      },
      child: CircleAvatar(
        radius: 40,
        backgroundColor:
            time == selectedTime ? Theme.of(context).primaryColor : Colors.grey,
        child: Text('$time\n' + 'min'.tr,
            textAlign: TextAlign.center,
            style: robotoBold.copyWith(
              color: time == selectedTime
                  ? Theme.of(context).cardColor
                  : Theme.of(context).primaryColor,
              fontSize: Dimensions.FONT_SIZE_LARGE,
            )),
      ),
    );
  }
}