import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/screens/myOrder/widget/orders_widget.dart';
import 'package:resturant_delivery_boy/view/screens/order/widget/permission_dialog.dart';

class MyOrderScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getAllOrders(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    checkPermission(context);

    return Scaffold(
      backgroundColor: ColorResources.kbackgroundColor,
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) => profileProvider.userInfoModel != null
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle, // Ensures the image is round
                              ),
                              child: ClipOval( // Use ClipOval to make the image round
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholderUser,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${profileProvider.userInfoModel!.image}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.placeholderUser,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 20),
                    Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) => profileProvider.userInfoModel != null
                          ? Text(
                              '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(
                getTranslated('active_order', context)!,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.w600, 
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                displacement: 0,
                color: ColorResources.COLOR_PRIMARY,
                backgroundColor: ColorResources.COLOR_WHITE,
                onRefresh: () {
                  return orderProvider.refresh(context);
                },
                child: orderProvider.currentOrders.isNotEmpty
                    ? ListView.builder(
                        itemCount: orderProvider.currentOrders.length,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (context, index) => OrderWidget(
                          orderModel: orderProvider.currentOrders[index],
                          index: index,
                        ),
                      )
                    :const Center(
                        child: CircularProgressIndicator(color: ColorResources.COLOR_PRIMARY,),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void checkPermission(BuildContext context, {Function? callBack}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (ctx) => PermissionDialog(isDenied: true, onPressed: () async {
          Navigator.pop(context);
          await Geolocator.requestPermission();
          if (callBack != null) {
            checkPermission(Get.context!, callBack: callBack);
          }
        }),
      );
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => PermissionDialog(isDenied: false, onPressed: () async {
          Navigator.pop(context);
          await Geolocator.openAppSettings();
          if (callBack != null) {
            checkPermission(Get.context!, callBack: callBack);
          }
        }),
      );
    } else if (callBack != null) {
      callBack();
    }
  }
}