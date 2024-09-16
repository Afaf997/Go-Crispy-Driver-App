 import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/screens/myOrder/widget/orders_widget.dart';
import 'package:resturant_delivery_boy/view/screens/order/widget/permission_dialog.dart';

import '../../../data/model/response/order_model.dart';

class MyOrderScreen extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  MyOrderScreen({Key? key}) : super(key: key);

  static void checkPermission(BuildContext context, {Function? callBack}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PermissionDialog(
          isDenied: true,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
            if (callBack != null) {
              checkPermission(context, callBack: callBack);
            }
          },
        ),
      );
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PermissionDialog(
          isDenied: false,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
            if (callBack != null) {
              checkPermission(context, callBack: callBack);
            }
          },
        ),
      );
    } else if (callBack != null) {
      callBack();
    }
  }

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<OrderModel> _previousOrders = [];
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).getAllOrders(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    Provider.of<OrderProvider>(context, listen: false)
        .addListener(_checkNewOrder);
  }

  @override
  void dispose() {
    Provider.of<OrderProvider>(context, listen: false)
        .removeListener(_checkNewOrder);
    _audioPlayer.dispose();
    super.dispose();
  }

  // Method to check for new orders and play notification sound
  void _checkNewOrder() {
    final currentOrders =
        Provider.of<OrderProvider>(context, listen: false).currentOrders;
    if (!_isFirstLoad && _previousOrders.length < currentOrders.length) {
      _playNotificationSound();
    }
    _isFirstLoad = false;
    _previousOrders = List.from(currentOrders);
  }


  Future<void> _playNotificationSound() async {
    await _audioPlayer.play(AssetSource('assets/audio/audio.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.kbackgroundColor,
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Profile Info
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
                        builder: (context, profileProvider, child) =>
                            profileProvider.userInfoModel != null
                                ? Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholderUser,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${profileProvider.userInfoModel!.image}',
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(
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
                        builder: (context, profileProvider, child) =>
                            profileProvider.userInfoModel != null
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
              // Active Orders Title
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
              // List of Active Orders
              Expanded(
                child: RefreshIndicator(
                  key: widget._refreshIndicatorKey,
                  onRefresh: () => orderProvider.refresh(context),
                  child: orderProvider.currentOrders.isNotEmpty
                      ? ListView.builder(
                          itemCount: orderProvider.currentOrders.length,
                          itemBuilder: (context, index) => OrderWidget(
                            orderModel: orderProvider.currentOrders[index],
                            index: index,
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: ColorResources.COLOR_PRIMARY,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}