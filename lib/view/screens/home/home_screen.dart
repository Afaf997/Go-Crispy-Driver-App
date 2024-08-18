import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/screens/home/widget/order_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final OrderModel? orderModel;

  HomeScreen({Key? key, this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

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
                          const Icon(Icons.circle, color: Colors.green, size: 12),
                          const SizedBox(width: 5),
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: true,
                              onChanged: (bool newValue) {},
                              activeColor: ColorResources.COLOR_WHITE,
                              activeTrackColor: ColorResources.COLOR_PRIMARY,
                            ),
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
        _buildStatistics(context),
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
                      itemCount: orderProvider.currentOrders.length,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (context, index) => HomeOrderWidget(
                        orderModel: orderProvider.currentOrders[index],
                        index: index,
                      ),
                    )
                  : Center(
                      child: Text(
                        getTranslated('no_order_found', context)!,
                      ),
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

  Widget _buildStatistics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(
              title: 'Total Orders',
              count: 
              color: ColorResources.COLOR_PRIMARY,
              width: 169,
              height: 160,
              countFontSize: 64,
            ),
            Column(
              children: [
                _buildStatCard(
                  title: 'Completed',
                  count: 
                  color: ColorResources.kbordergreenColor,
                  width: 170,
                  height: 78,
                  countFontSize: 38,
                ),
                const SizedBox(height: 4),
                _buildStatCard(
                  title: 'Pending',
                  count: 
                  color: ColorResources.kborderyellowColor,
                  width: 170,
                  height: 78,
                  countFontSize: 38,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveOrdersTitle() {
    return const Text(
      'Active Orders',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required Color color,
    required double width,
    required double height,
    required double countFontSize,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15,top: 7,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: countFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
