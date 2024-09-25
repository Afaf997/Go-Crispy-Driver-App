// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/repository/response_model.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:resturant_delivery_boy/data/model/response/config_model.dart';
import 'package:resturant_delivery_boy/data/model/response/order_details_model.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/helper/date_converter.dart';
import 'package:resturant_delivery_boy/helper/price_converter.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/provider/time_provider.dart';
import 'package:resturant_delivery_boy/provider/tracker_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/screens/chat/chat_screen.dart';
import 'package:resturant_delivery_boy/view/screens/myOrder/my_order_screen.dart';
import 'package:resturant_delivery_boy/view/screens/myOrder/widget/orders_widget.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_place_screen.dart';
import 'package:resturant_delivery_boy/view/screens/order/widget/custom_divider.dart';
import 'package:resturant_delivery_boy/view/screens/order/widget/delivery_dialog.dart';
import 'package:resturant_delivery_boy/view/screens/order/widget/slider_button.dart';
import 'package:resturant_delivery_boy/view/screens/order/widget/timer_view.dart';

class BranchDetailsScreen extends StatefulWidget {
  final OrderModel? orderModelItem;
   final ConfigModel? configModel;
   BranchDetailsScreen({
    Key? key,
    this.orderModelItem,
    this.configModel,
  }) : super(key: key);

  @override
  State<BranchDetailsScreen> createState() => _BranchDetailsScreenState();
}

class _BranchDetailsScreenState extends State<BranchDetailsScreen> {
  bool _isPickedUp = false; 
  
      ConfigModel? configModel;
  OrderModel? orderModel;
  double? deliveryCharge = 0;
  



  @override
  void initState() {
   Provider.of<SplashProvider>(context, listen: false).initConfig(context);
   
    orderModel = widget.orderModelItem;

    _loadData();
    


    super.initState();
  }
  

  _loadData() {
    if(orderModel!.orderAmount == null) {
      Provider.of<OrderProvider>(context, listen: false).getOrderModel('${orderModel!.id}').then((OrderModel? value) {
        orderModel = value;
        if(orderModel?.orderType == 'delivery') {
          deliveryCharge = orderModel?.deliveryCharge;
        }
      }).then((value) {
        Provider.of<OrderProvider>(context, listen: false).getOrderDetails(orderModel!.id.toString(), context).then((value) {
          Provider.of<TimerProvider>(context, listen: false).countDownTimer(orderModel!, context);
        });
      });
    
    }else{
      if(orderModel?.orderType == 'delivery') {
        deliveryCharge = orderModel?.deliveryCharge;
      }

      Provider.of<OrderProvider>(context, listen: false).getOrderDetails(orderModel!.id.toString(), context).then((value) {
        Provider.of<TimerProvider>(context, listen: false).countDownTimer(orderModel!, context);
      });
    }
  }
  


  @override
  Widget build(BuildContext context) {
      Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    return Scaffold(
      backgroundColor: ColorResources.COLOR_WHITE,
      appBar: AppBar(
        backgroundColor:ColorResources.COLOR_WHITE,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          getTranslated('order_details', context)!,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge!.color,fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {

          double itemsPrice = 0;
          double discount = 0;
          double tax = 0;
          double addOns = 0;
          double subTotal = 0;
          double totalPrice = 0;
          if (order.orderDetails != null && orderModel!.orderAmount != null) {


            for (var orderDetails in order.orderDetails!) {
              List<double> addonPrices = orderDetails.addOnPrices ?? [];
              List<int> addonsIds = orderDetails.addOnIds != null ? orderDetails.addOnIds! : [];

              if(addonsIds.length == addonPrices.length &&
                  addonsIds.length == orderDetails.addOnQtys?.length){
                for(int i = 0; i < addonsIds.length; i++){
                  addOns = addOns + (addonPrices[i] * orderDetails.addOnQtys![i]);
                }
              }

              itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              discount = discount + (orderDetails.discountOnProduct! * orderDetails.quantity!);
              tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!) + orderDetails.addonTaxAmount!;
            }
            subTotal = itemsPrice + tax + addOns;
            totalPrice = subTotal - discount + deliveryCharge! - orderModel!.couponDiscountAmount!;


          }

          List<OrderPartialPayment> paymentList = [];
          if(orderModel != null && orderModel!.orderPartialPayments != null && orderModel!.orderPartialPayments!.isNotEmpty){
            paymentList = [];
            paymentList.addAll(orderModel!.orderPartialPayments!);

            if(orderModel?.paymentStatus == 'partial_paid'){
              paymentList.add(OrderPartialPayment(
                paidAmount: 0, paidWith: orderModel!.paymentMethod,
                dueAmount: orderModel!.orderPartialPayments!.first.dueAmount,
              ));
            }
          }


          return order.orderDetails != null && orderModel!.orderAmount != null
              ? Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  children: [
                    Row(children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${getTranslated('order_id', context)}', style: rubikRegular),
                            Text(' # ${orderModel!.id}', style: rubikMedium),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.watch_later, size: 17),
                            orderModel!.deliveryTime == null ? Text(DateConverter.isoStringToLocalDateOnly(orderModel!.createdAt!),
                              style: rubikRegular,
                            ) : Text(
                              DateConverter.deliveryDateAndTimeToDate(orderModel!.deliveryDate!, orderModel!.deliveryTime!, context),
                              style: rubikRegular,
                            ),
                          ],
                        ),
                      ),
                    ]),

                    if(orderModel!.orderStatus == 'pending'
                        || orderModel!.orderStatus == 'confirmed'
                        || orderModel!.orderStatus == 'processing'
                        || orderModel!.orderStatus == 'out_for_delivery'
                    ) const TimerView(),


                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: ColorResources.COLOR_WHITE,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(
                          color: Theme.of(context).shadowColor,
                           spreadRadius: 1,
                           
                        )],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated('customer', context)!, style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              )),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderUser, height: 40, width: 40, fit: BoxFit.cover,
                              image: orderModel!.customer != null
                                  ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${orderModel!.customer!.image ?? ''}' : '',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, height: 40, width: 40, fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(
  orderModel?.deliveryAddress != null
      ? (Provider.of<SplashProvider>(context, listen: false)
              .configModel?.branches
              ?.map((branch) => branch.id == orderModel?.branchId ? branch.name : null)
              .firstWhere((name) => name != null, orElse: () => 'Default Name'))
          ?? 'Default Name'
      : '',
  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
),
                        ),

                      ]),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text('${getTranslated('item', context)}:', style: rubikRegular),
                          const SizedBox(width: Dimensions.fontSizeLarge),
                          Text(order.orderDetails!.length.toString(), style: rubikMedium),
                        ]),

                        orderModel!.orderStatus == 'processing' || orderModel!.orderStatus == 'out_for_delivery' ? Row(children: [
                          Text('${getTranslated('payment_status', context)}:', style: rubikRegular),
                          const SizedBox(width: Dimensions.fontSizeLarge),
                          Text(getTranslated('${orderModel!.paymentStatus}', context)!,
                              style: rubikMedium.copyWith(color: ColorResources.COLOR_PRIMARY,)),
                        ])
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const Divider(height: 20),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.orderDetails!.length,
                      itemBuilder: (context, index) {
                        List<AddOns> addOns = [];
                        String variationText = '';

                        if(order.orderDetails![index].addOnIds != null){
                          for (var addOnsId in order.orderDetails![index].addOnIds!) {
                            for (var addons in order.orderDetails![index].productDetails!.addOns!) {
                              if(addons.id == addOnsId) {
                                addOns.add(addons);
                              }
                            }
                          }
                        }

                        if(order.orderDetails![index].variations != null && order.orderDetails![index].variations!.isNotEmpty) {
                          for(Variation variation in order.orderDetails![index].variations!) {
                            variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                            for(VariationValue value in variation.variationValues!) {
                              variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level}';
                            }
                            variationText += ')';
                          }
                        }else if(order.orderDetails![index].oldVariations != null && order.orderDetails![index].oldVariations!.isNotEmpty) {
                          List<String> variationTypes = order.orderDetails![index].oldVariations![0].type!.split('-');
                          if(variationTypes.length == order.orderDetails![index].productDetails!.choiceOptions!.length) {
                            int index = 0;
                            for (var choice in order.orderDetails![index].productDetails!.choiceOptions!) {
                              variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
                              index = index + 1;
                            }
                          }else {
                            variationText = order.orderDetails![index].oldVariations![0].type ?? '';
                          }
                        }

                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholderImage, height: 70, width: 80, fit: BoxFit.cover,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.orderDetails![index].productDetails!.image}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 70, width: 80, fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        order.orderDetails![index].productDetails!.name!,
                                        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(getTranslated('amount', context)!, style: rubikRegular),
                                  ],
                                ),
                                const SizedBox(height: Dimensions.fontSizeLarge),

                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Row(
                                    children: [
                                      Text('${getTranslated('quantity', context)}:',
                                          style: rubikRegular),
                                      Text(' ${order.orderDetails![index].quantity}',
                                          style: rubikMedium.copyWith(color:ColorResources.COLOR_PRIMARY,)),
                                    ],
                                  ),
                                  Text(
                                    PriceConverter.convertPrice(context, order.orderDetails![index].price),
                                    style: rubikMedium.copyWith(color: ColorResources.COLOR_PRIMARY),
                                  ),
                                ]),
                                const SizedBox(height: Dimensions.paddingSizeSmall),


                                variationText != '' ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Container(height: 10, width: 10, decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                      )),
                                      const SizedBox(width: Dimensions.fontSizeLarge),

                                      Expanded(
                                        child: Text(variationText,
                                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        ),
                                      ),
                                    ]) :const SizedBox(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ProductTypeView(productType: order.orderDetails![index].productDetails!.productType),
                                  ],
                                ) ,
                              ]),
                            ),
                          ]),
                          addOns.isNotEmpty
                              ? SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                              itemCount: addOns.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  child: Row(children: [
                                    Text(addOns[i].name!, style: rubikRegular),
                                    const SizedBox(width: 2),
                                    Text(
                                      PriceConverter.convertPrice(context, addOns[i].price),
                                      style: rubikMedium,
                                    ),
                                    const SizedBox(width: 2),
                                    Text('(${order.orderDetails![index].addOnQtys![i]})', style: rubikRegular),
                                  ]),
                                );
                              },
                            ),
                          )
                              : const SizedBox(),
                          const Divider(height: 20),
                        ]);
                      },
                    ),

                    (orderModel!.orderNote != null && orderModel!.orderNote!.isNotEmpty) ? Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Theme.of(context).hintColor),
                      ),
                      child: Text(orderModel!.orderNote!, style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                    ) : const SizedBox(),

                    // Total
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('items_price', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text(PriceConverter.convertPrice(context, itemsPrice), style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('tax', context)!,
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text('(+) ${PriceConverter.convertPrice(context, tax)}',
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('addons', context)!,
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text('(+) ${PriceConverter.convertPrice(context, addOns)}',
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: CustomDivider(),
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('subtotal', context)!,
                          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text(PriceConverter.convertPrice(context, subTotal),
                          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('discount', context)!,
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text('(-) ${PriceConverter.convertPrice(context, discount)}',
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('coupon_discount', context)!,
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text(
                        '(-) ${PriceConverter.convertPrice(context, orderModel!.couponDiscountAmount)}',
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('delivery_fee', context)!,
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: CustomDivider(),
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('total_amount', context)!,
                          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: ColorResources.COLOR_PRIMARY)),
                      Text(
                        PriceConverter.convertPrice(context, totalPrice),
                        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: ColorResources.COLOR_PRIMARY),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                   if(orderModel?.orderPartialPayments != null && orderModel!.orderPartialPayments!.isNotEmpty)
                     DottedBorder(
                       dashPattern: const [8, 4],
                       strokeWidth: 1.1,
                       borderType: BorderType.RRect,
                       color: Theme.of(context).colorScheme.primary,
                       radius: const Radius.circular(Dimensions.radiusDefault),
                       child: Container(
                         decoration: BoxDecoration(
                           color: ColorResources.COLOR_PRIMARY.withOpacity(0.02),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall, vertical: 1),
                         child: Column(children: paymentList.map((payment) => Padding(
                           padding: const EdgeInsets.symmetric(vertical: 1),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                             Text("${getTranslated(payment.paidAmount! > 0 ? 'paid_amount' : 'due_amount', context)} (${getTranslated('${payment.paidWith}', context)})",
                               style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                               overflow: TextOverflow.ellipsis,),

                             Text( PriceConverter.convertPrice(context, payment.paidAmount! > 0 ? payment.paidAmount : payment.dueAmount),
                               style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),),
                           ],
                           ),
                         )).toList()),
                       ),
                     ),



                    const SizedBox(height: 30),
                  ],
                ),
              ),
              orderModel!.orderStatus == 'processing' || orderModel!.orderStatus == 'out_for_delivery'
                  ?Center(
  child: Padding(
    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
    child: SizedBox(
      width: 1170,
      child: CustomButton(
        btnTxt: getTranslated('Branch location', context),
        onTap: () async {
          try {
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            _showDirectionOptions(context, position);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unable to get current location. Please enable location services.')),
            );
          }
        },
      ),
    ),
  ),
)

                  : const SizedBox.shrink(),

       orderModel!.orderStatus == 'done' || orderModel!.orderStatus == 'processing'
  ? Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
        color: Theme.of(context).canvasColor,
      ),
      child: Transform.rotate(
        angle: Provider.of<LocalizationProvider>(context).isLtr ? pi * 2 : pi, // in radians
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: _isPickedUp 
          ? Center( 
              child: Text(
                getTranslated('already picked up', context)!,
                style: TextStyle(color: Colors.green),
              ),
            )
          : SliderButton( 
              action: () async {
                String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                ResponseModel response = await Provider.of<OrderProvider>(context, listen: false)
                    .updatedeliveryorder(token: token, orderId: orderModel!.id);

                if (response.isSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(getTranslated('success', context)!),
                          content:const Text("Successfully picked the order"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isPickedUp = true; // Update the state to mark as picked up
                                });
                                Navigator.of(context).pop(); // Close the popup
                              },
                              child: Text(getTranslated('ok', context)!),
                            ),
                          ],
                        );
                      },
                    );
                  });
                } else {
                  // Handle failure case if needed
                }
              },
              label: Text(
                getTranslated('swipe to pickup', context)!,
              ),
              dismissThresholds: 0.5,
              dismissible: false,
              icon: const Center(
                child: Icon(
                  Icons.double_arrow_sharp,
                  color: Colors.white,
                  size: 20.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ),
              radius: 10,
              boxShadow: const BoxShadow(blurRadius: 0.0),
              buttonColor: ColorResources.COLOR_PRIMARY,
              backgroundColor: Theme.of(context).canvasColor,
              baseColor: ColorResources.COLOR_PRIMARY,
            ),
        ),
      ),
    )
  : const SizedBox.shrink()

            ],
          )
              : const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY)));
        },
      ),
    );
  }
  void _showDirectionOptions(BuildContext context, Position position) {
  var branch = Provider.of<SplashProvider>(context, listen: false)
      .configModel?.branches
      ?.firstWhere(
        (branch) => branch.id == orderModel?.branchId,
      );

  // Extract latitude and longitude from the branch or fallback to defaults
  double destinationLatitude = branch?.latitude != null
      ?double.tryParse(branch?.latitude ?? '23.8103')?.toDouble() ?? 23.8103
      : 23.8103;
  double destinationLongitude = branch?.longitude != null
      ? double.tryParse(branch?.longitude ?? '23.8103')?.toDouble() ?? 23.8103
      : 90.4125;

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
                destinationLatitude,
                destinationLongitude,
                position.latitude,
                position.longitude,
                true, // Pass true to indicate Google Maps
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Waze'),
            onTap: () async {
              Navigator.pop(context);
              await MapUtils.openMap(
                destinationLatitude,
                destinationLongitude,
                position.latitude,
                position.longitude,
                false, // Pass false to indicate Waze
              );
            },
          ),
        ],
      );
    },
  );
}

}


class ProductTypeView extends StatelessWidget {
  final String? productType;
  const ProductTypeView({Key? key, this.productType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isActive = Provider.of<SplashProvider>(context, listen: false).configModel!.isVegNonVegActive!;
    return (productType == null || !isActive)  ? const SizedBox() : Container(
      decoration:const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: ColorResources.COLOR_PRIMARY,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0 ,vertical: 2),
        child: Text(getTranslated(productType, context,
        )!, style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
        ),
      ),
    );
  }


}
class MapUtils {
  MapUtils._();

  static Future<void> openMap(double destinationLatitude, double destinationLongitude, double userLatitude, double userLongitude, bool isGoogleMap) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$destinationLatitude,$destinationLongitude&mode=d';
    String wazeUrl = 'https://waze.com/ul?ll=$destinationLatitude,$destinationLongitude&navigate=yes';

    String url = isGoogleMap ? googleUrl : wazeUrl;

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
  
}


