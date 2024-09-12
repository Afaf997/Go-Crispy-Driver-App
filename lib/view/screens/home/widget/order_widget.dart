import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeOrderWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final int index;
  const HomeOrderWidget({Key? key, this.orderModel, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                 Text(
  getTranslated('order_id', context)!,
  style:const TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.w500, 
  ),
),
Text(
  ' # ${orderModel!.id.toString()}',
  style:const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, 
  ),
),

                  ],
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(),
                    Positioned(
                      right: Provider.of<LocalizationProvider>(context).isLtr ? 0 : null,
                      left: Provider.of<LocalizationProvider>(context).isLtr ? null : 0,
                      top: -10, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2, 
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: ColorResources.kbordergreenColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          getTranslated('${orderModel!.orderStatus}', context)!,
                          style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Image.asset(
                  Images.location,
                  color: ColorResources.COLOR_BLACK,
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    orderModel!.deliveryAddress != null
                        ? orderModel!.deliveryAddress!.address!
                        : 'Address not found',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
       Row(
  children: [
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(orderModelItem: orderModel)));
      },
      child: Text(
        getTranslated('view_details', context)!,
        style:const TextStyle(
          color:ColorResources.kborderyellowColor , 
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    ),
    const SizedBox(width: 20),
   CustomButton(
  isShowBorder: true,
  borderColor: ColorResources.Boarder_COLOR,
  buttonColor: ColorResources.COLOR_WHITE,
  btnTxt: getTranslated('take me there', context)!,
  textColor:ColorResources.COLOR_PRIMARY, 
  onTap: () async {
     Navigator.pop(context);
                _openWaze(context);
  },
),

  ],
),

          ],
        ),
      ),
    );
  }
    Future<void> _openWaze(BuildContext context) async {
    String url =
        'https://waze.com/ul?ll=${orderModel!.deliveryAddress!.latitude},${orderModel!.deliveryAddress!.longitude}&navigate=yes';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
