  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/provider/status_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/view/screens/home/widget/state_card.dart';

Widget buildStatistics(BuildContext context) {
  return Consumer<StatusProvider>(
    builder: (context, statusProvider, child) {
      if (statusProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (statusProvider.orderCountModel != null) {
        final totalOrders = statusProvider.orderCountModel!.allOrders.toString();
        final completedOrders = statusProvider.orderCountModel!.completedOrders.toString();
        final pendingOrders = statusProvider.orderCountModel!.pendingOrders.toString();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatCard(
                  title: 'Total Orders',
                  count: totalOrders, // Use actual count value
                  color: ColorResources.COLOR_PRIMARY,
                  width: 169,
                  height: 155,
                  countFontSize: 60,
                ),
                Column(
                  children: [
                    buildStatCard(
                      title: 'Completed',
                      count: completedOrders, // Use actual count value
                      color: ColorResources.kbordergreenColor,
                      width: 170,
                      height: 78,
                      countFontSize: 38,
                    ),
                    const SizedBox(height: 4),
                    buildStatCard(
                      title: 'Pending',
                      count: pendingOrders, // Use actual count value
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
      } else {
        return const Center(child: Text('No Data Available'));
      }
    },
  );
}
