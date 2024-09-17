import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/current_order.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final CurrentOrder? currentOrder;
  final int index;
  const OrderWidget({Key? key, this.orderModel, required this.index, this.currentOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
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
                    ),
                    Text(
                      ' # ${orderModel!.id.toString()}',
                    ),
                  ],
                ),

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(),
                    Provider.of<LocalizationProvider>(context).isLtr
                        ? Positioned(
                            right: -10,
                            top: -23,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.fontSizeLarge,
                                  horizontal: Dimensions.paddingSizeDefault),
                              decoration: const BoxDecoration(
                                  color: ColorResources.COLOR_PRIMARY,
                                  borderRadius: BorderRadius.only(
                                      topRight:
                                          Radius.circular(Dimensions.paddingSizeSmall),
                                      bottomLeft:
                                          Radius.circular(Dimensions.paddingSizeSmall))),
                              child: Text(
                                getTranslated('${orderModel!.orderStatus}', context)!,
                                style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).cardColor),
                              ),
                            ),
                          )
                        : Positioned(
                            left: -10,
                            top: -28,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.fontSizeLarge,
                                  horizontal: Dimensions.paddingSizeDefault),
                              decoration: const BoxDecoration(
                                  color: ColorResources.COLOR_PRIMARY,
                                  borderRadius: BorderRadius.only(
                                      topRight:
                                          Radius.circular(Dimensions.paddingSizeSmall),
                                      bottomLeft:
                                          Radius.circular(Dimensions.paddingSizeSmall))),
                              child: Text(
                                getTranslated('${orderModel!.orderStatus}', context)!,
                                style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).cardColor),
                              ),
                            ),
                          )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
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
                // Text(currentOrder?.branchId?.toString() ?? 'No branch ID available')
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    btnTxt: getTranslated('view_details', context),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OrderDetailsScreen(
                              orderModelItem: orderModel)));
                    },
                    isShowBorder: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    btnTxt: getTranslated('direction', context),
                    onTap: () {
                      _showDirectionOptions(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDirectionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Google Maps'),
              onTap: () {
                Navigator.pop(context);
                _openGoogleMap(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Waze'),
              onTap: () {
                Navigator.pop(context);
                _openWaze(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openGoogleMap(BuildContext context) async {
    String url =
        'https://www.google.com/maps/dir/?api=1&destination=${orderModel!.deliveryAddress!.latitude},${orderModel!.deliveryAddress!.longitude}&mode=d';
    log(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _openWaze(BuildContext context) async {
    String url =
        'https://waze.com/ul?ll=${orderModel!.deliveryAddress!.latitude},${orderModel!.deliveryAddress!.longitude}&navigate=yes';
    log(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}


class MapUtils {
  MapUtils._();
  
  static Future<void> openMap(double destinationLatitude, double destinationLongitude, double userLatitude, double userLongitude) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$destinationLatitude,$destinationLongitude&mode=d';
    String wazeUrl =
        'https://www.waze.com/live-map/$destinationLatitude,$destinationLongitude&navigate=yes';

    bool canLaunchGoogle = await canLaunchUrl(Uri.parse(googleUrl));
    bool canLaunchWaze = await canLaunchUrl(Uri.parse(wazeUrl));
  }
}

