import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final bool isShowBorder;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor; // Add this parameter

  const CustomButton({
    Key? key,
    this.onTap,
    required this.btnTxt,
    this.isShowBorder = false,
    this.buttonColor,
    this.borderColor,
    this.textColor, // Include in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16), // Optional padding
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: !isShowBorder ? Colors.grey.withOpacity(0.2) : Colors.transparent,
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isShowBorder
              ? borderColor ?? Colors.black // Set default border color if not provided
              : Colors.transparent,
        ),
        color: !isShowBorder ? buttonColor ?? ColorResources.COLOR_PRIMARY : Colors.transparent,
      ),
      child: TextButton(
        onPressed: onTap as void Function()?,
        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              btnTxt ?? "",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: textColor ?? (!isShowBorder ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color),
                  fontSize: Dimensions.fontSizeDefault),
            ),
          ],
        ),
      ),
    );
  }
}
