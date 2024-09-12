import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/provider/status_provider.dart';
import 'package:resturant_delivery_boy/provider/online_provider.dart'; // Add this import
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/screens/home/widget/order_widget.dart';
import 'package:resturant_delivery_boy/view/screens/home/widget/state_card.dart';
import 'package:resturant_delivery_boy/view/screens/home/widget/statistics.dart';

class HomeScreen extends StatefulWidget {
  final OrderModel? orderModel;

  HomeScreen({Key? key, this.orderModel}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    // Fetch user info and status info
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    Provider.of<StatusProvider>(context, listen: false).getStatusInfo(context);
    Provider.of<OnlineProvider>(context, listen: false).getInitialStatus(context); 
     Provider.of<OnlineProvider>(context, listen: false).toggleOnlineStatus(context);// Initialize status
     Provider.of<OrderProvider>(context, listen: false).getAllOrders(context);

    return Scaffold(
      backgroundColor: ColorResources.kbackgroundColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 238,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<OnlineProvider>(
                            builder: (context, onlineProvider, child) {
                              bool isOnline = onlineProvider.onlineModel?.status == 'online';
                              return Row(
                                children: [
                                  // Icon(
                                  //   isOnline ? Icons.circle : Icons.circle,
                                  //   color: isOnline ? Colors.green : Colors.red,
                                  //   size: 12,
                                  // ),
                                  const SizedBox(width: 5),
                                  // Text(
                                  //   isOnline ? 'Online' : 'Offline',
                                  //   style: const TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w500,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  // Transform.scale(
                                  //   scale: 0.7,
                                  //   child: Switch(
                                  //     value: isOnline,
                                  //     onChanged: (bool newValue) {
                                  //       onlineProvider.toggleOnlineStatus(context);
                                  //     },
                                  //     activeColor: ColorResources.COLOR_WHITE,
                                  //     activeTrackColor: ColorResources.COLOR_PRIMARY,
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
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
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
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
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(thickness: 0.2, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildStatistics(context),
                  const SizedBox(height: 11),
                  _buildActiveOrdersTitle(),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 400,
                    child: Consumer<OrderProvider>(
                      builder: (context, orderProvider, child) => RefreshIndicator(
                        key: _refreshIndicatorKey,
                        color: ColorResources.COLOR_PRIMARY,
                        backgroundColor: ColorResources.COLOR_WHITE,
                        onRefresh: () {
                          return orderProvider.refresh(context);
                        },
                        child: orderProvider.currentOrders.isNotEmpty
                            ? ListView.builder(
                                itemCount: 5,
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                itemBuilder: (context, index) => HomeOrderWidget(
                                  orderModel: orderProvider.currentOrders[index],
                                  index: index,
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(color: ColorResources.COLOR_PRIMARY,),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrdersTitle() {
    return const Text(
      'Active Orders',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }
}
