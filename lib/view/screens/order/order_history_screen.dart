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

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false)
        .getOrderHistory(context, false, null);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.kbackgroundColor,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        elevation: 0,
        actions: [
          selectedDateRange == null
              ? IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () {
                    selectDateRange(context);
                  },
                )
              : TextButton(
                  child: const Text("Clear Filter"),
                  onPressed: () {
                    Provider.of<OrderProvider>(context, listen: false)
                        .getOrderHistory(context, false, null);
                    setState(() {
                      selectedDateRange = null;
                    });
                  },
                ),
        ],
        backgroundColor: ColorResources.COLOR_WHITE,
        title: Text(
          getTranslated('order_history', context)!,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: ColorResources.COLOR_BLACK,
              fontSize: Dimensions.fontSizeExtraLarge,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          if (order.isOrderHistoryLoading) {
            print("heyyyyyyy");
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
              ),
            );
          }
          return order.allOrderHistory != null
              ? order.allOrderHistory!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () => order.refresh(context),
                      displacement: 20,
                      color: Colors.white,
                      backgroundColor: ColorResources.COLOR_PRIMARY,
                      key: _refreshIndicatorKey,
                      child: order.allOrderHistory!.isNotEmpty
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                const Text("Total Amount"),
                                Text(
                                  PriceConverter.convertPrice(
                                      context, order.orderHistoryTotal),
                                  style: rubikMedium.copyWith(
                                      color: ColorResources.COLOR_PRIMARY,
                                      fontSize: 24),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: order.allOrderHistory!.length,
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          OrderDetailsScreen(
                                                              orderModelItem:
                                                                  order.allOrderHistory![
                                                                      index])));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              margin: const EdgeInsets.only(
                                                  bottom: Dimensions
                                                      .paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                color:
                                                    ColorResources.COLOR_WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(children: [
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeSmall),
                                                      Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${getTranslated('order_id', context)} #${order.allOrderHistory![index].id}',
                                                                      style: rubikMedium.copyWith(
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall,
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyLarge!
                                                                              .color),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      getTranslated(
                                                                          'amount',
                                                                          context)!,
                                                                      style: rubikRegular.copyWith(
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyLarge!
                                                                              .color)),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .fontSizeLarge),
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            getTranslated('status',
                                                                                context)!,
                                                                            style:
                                                                                rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                                                        Text(
                                                                            getTranslated('${order.allOrderHistory![index].orderStatus}',
                                                                                context)!,
                                                                            style:
                                                                                rubikMedium.copyWith(color: ColorResources.COLOR_PRIMARY)),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                        PriceConverter.convertPrice(
                                                                            context,
                                                                            (order.allOrderHistory![index].orderAmount ?? 0) +
                                                                                (order.allOrderHistory![index].deliveryCharge ??
                                                                                    0)),
                                                                        style: rubikMedium.copyWith(
                                                                            color:
                                                                                ColorResources.COLOR_PRIMARY)),
                                                                  ]),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .paddingSizeSmall),
                                                              Row(children: [
                                                                Container(
                                                                    height: 10,
                                                                    width: 10,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge!
                                                                            .color)),
                                                                const SizedBox(
                                                                    width: Dimensions
                                                                        .fontSizeLarge),
                                                                Text(
                                                                  '${getTranslated('order_at', context)}${DateConverter.isoStringToLocalDateOnly(order.allOrderHistory![index].updatedAt!)}',
                                                                  style: rubikRegular.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color),
                                                                ),
                                                              ]),
                                                            ]),
                                                      ),
                                                    ]),
                                                  ]),
                                            ),
                                          )),
                                ),
                              ],
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 130),
                                child: Text(
                                  getTranslated('no_data_found', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                    )
                  : Center(
                      child: Text(
                      getTranslated('no_history_available', context)!,
                    ))
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }

  Future<void> selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        filterOrdersByDate(); // Filter the orders once the date range is selected
      });
    }
  }

  void filterOrdersByDate() {
    if (selectedDateRange != null) {
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderHistory(context, true, selectedDateRange);
    }
  }
}
