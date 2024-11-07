import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/screens/home/widget/branch_location_details.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeOrderWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final int index;
  const HomeOrderWidget({Key? key, this.orderModel, required this.index})
      : super(key: key);

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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' # ${orderModel!.id.toString()}',
                      style: const TextStyle(
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
                      right: Provider.of<LocalizationProvider>(context).isLtr
                          ? 0
                          : null,
                      left: Provider.of<LocalizationProvider>(context).isLtr
                          ? null
                          : 0,
                      top: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderModel!.deliveryAddress != null
                            ? orderModel!.deliveryAddress!.address!
                            : 'Address not found',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        orderModel?.deliveryAddress != null
                            ? (Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel
                                    ?.branches
                                    ?.map((branch) =>
                                        branch.id == orderModel?.branchId
                                            ? branch.name
                                            : null)
                                    .firstWhere((name) => name != null,
                                        orElse: () => 'Default Name')) ??
                                'Default Name'
                            : '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
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
                        builder: (_) => OrderDetailsScreen(
                              orderModelItem: orderModel,
                              isAlreadyCollectedOrNot:
                                  orderModel!.orderStatus == 'out_for_delivery'
                                      ? true
                                      : false,
                            )));
                  },
                  child: Text(
                    getTranslated('Delivery', context)!,
                    style: const TextStyle(
                      color: ColorResources.kborderyellowColor,
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
                    btnTxt: orderModel!.orderStatus == 'out_for_delivery'
                        ? getTranslated('Already Collected', context)!
                        : getTranslated('Collect Order', context)!,
                    textColor: ColorResources.COLOR_PRIMARY,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BranchDetailsScreen(
                                  orderModelItem: orderModel)));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDirectionOptions(BuildContext context, Position position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Google Maps'),
              onTap: () async {
                Navigator.pop(context);
                await MapUtils.openMap(
                    double.tryParse(orderModel!.deliveryAddress!.latitude!) ??
                        23.8103,
                    double.tryParse(orderModel!.deliveryAddress!.longitude!) ??
                        90.4125,
                    position.latitude,
                    position.longitude,
                    true // Pass true to indicate Google Maps
                    );
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Waze'),
              onTap: () async {
                Navigator.pop(context);
                await MapUtils.openMap(
                    double.tryParse(orderModel!.deliveryAddress!.latitude!) ??
                        23.8103,
                    double.tryParse(orderModel!.deliveryAddress!.longitude!) ??
                        90.4125,
                    position.latitude,
                    position.longitude,
                    false // Pass false to indicate Waze
                    );
              },
            ),
          ],
        );
      },
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double destinationLatitude,
      double destinationLongitude,
      double userLatitude,
      double userLongitude,
      bool isGoogleMap) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
    String wazeUrl =
        'https://waze.com/ul?ll=$destinationLatitude,$destinationLongitude&navigate=yes';

    if (isGoogleMap) {
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrlString(googleUrl);
      } else {
        throw 'Could not launch Google Maps';
      }
    } else {
      if (await canLaunchUrl(Uri.parse(wazeUrl))) {
        await launchUrlString(wazeUrl);
      } else {
        throw 'Could not launch Waze';
      }
    }
  }
}
