import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget rowBarSetting(
    BuildContext context,
    String title,
    List<DropdownMenuItem<dynamic>> items,
    ValueChanged<dynamic>? onChanged,
    String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:  TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              fontSize: 14.sp
            )),
        DropdownButton(
          items: items,
          onChanged: onChanged,
          icon: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Icon(
              Icons.arrow_downward,
              color: Theme.of(context).cardColor,
              size: 20,
            ),
          ),
          hint: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                child: Text(
                  value,
                  style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              fontSize: 12.sp
            ),
                )),
          ),
          dropdownColor: Theme.of(context).primaryColor,
          elevation: 12,
          underline: Container(),
          iconSize: 40,
        )
      ],
    ),
  );
}
