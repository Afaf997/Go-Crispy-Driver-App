import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/helper/date_converter.dart';
import 'package:resturant_delivery_boy/helper/price_converter.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderHistory(context);
    return Scaffold(
      backgroundColor: ColorResources.SEARCH_BG,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        elevation: 0,
        backgroundColor:ColorResources.COLOR_WHITE,
        title: Text(
          getTranslated('order_history', context)!,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorResources.COLOR_BLACK, fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) => order.allOrderHistory != null ? order.allOrderHistory!.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () => order.refresh(context),
                displacement: 20,
                color: Colors.white,
                backgroundColor:ColorResources.COLOR_PRIMARY,
                key: _refreshIndicatorKey,
                child: order.allOrderHistory!.isNotEmpty
                    ? ListView.builder(
                        itemCount: order.allOrderHistory!.length,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModelItem: order.allOrderHistory![index])));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: ColorResources.COLOR_WHITE,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).shadowColor.withOpacity(.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${getTranslated('order_id', context)} #${order.allOrderHistory![index].id}',
                                                style:
                                                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(getTranslated('amount', context)!, style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.fontSizeLarge),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Row(
                                            children: [
                                              Text(getTranslated('status', context)!,
                                                  style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                              Text(getTranslated('${order.allOrderHistory![index].orderStatus}', context)!,
                                                  style: rubikMedium.copyWith(color:ColorResources.COLOR_PRIMARY)),
                                            ],
                                          ),
                                          Text(PriceConverter.convertPrice(context, (order.allOrderHistory![index].orderAmount ?? 0)  +  (order.allOrderHistory![index].deliveryCharge ?? 0)),
                                              style: rubikMedium.copyWith(color: ColorResources.COLOR_PRIMARY)),
                                        ]),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        Row(children: [
                                          Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                          const SizedBox(width: Dimensions.fontSizeLarge),
                                          Text(
                                            '${getTranslated('order_at', context)}${DateConverter.isoStringToLocalDateOnly(order.allOrderHistory![index].updatedAt!)}',
                                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                          ),
                                        ]),
                                      ]),
                                    ),
                                  ]),
                                ]),
                              ),
                            ))
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 130),
                          child: Text(
                            getTranslated('no_data_found', context)!,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
              ) : Center(child: Text(
          getTranslated('no_history_available', context)!,
          style: Theme.of(context).textTheme.displaySmall,
        )) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
      ),
    );
  }
}
