import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/screens/html/html_viewer_screen.dart';
import 'package:resturant_delivery_boy/view/screens/profile/widget/profile_button.dart';

import 'widget/sign_out_confirmation_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => profileProvider.isLoading ? const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                 decoration: const BoxDecoration(
                   color: ColorResources.COLOR_BLACK,
                   borderRadius: BorderRadius.only(
                     bottomLeft: Radius.circular(24), 
                     bottomRight: Radius.circular(24), 
                   ),
  ),
                  width: MediaQuery.of(context).size.width,
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        getTranslated('my_profile', context)!,
                        style: rubikRegular.copyWith(fontSize:18, color: Colors.white,fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderUser, width: 80, height: 80, fit: BoxFit.fill,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${profileProvider.userInfoModel!.image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, width: 80, height: 80, fit: BoxFit.fill),
                            )),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        profileProvider.userInfoModel!.fName != null
                            ? '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}'
                            : "",
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                Container(
                  color:Colors.white,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel!.fName),
                      const SizedBox(height: 15),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel!.lName),
                      const SizedBox(height: 15),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel!.phone),
                      const SizedBox(height: 20),
                      ProfileButton(icon: Icons.privacy_tip, title: getTranslated('privacy_policy', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: true)));
                      }),
                      const SizedBox(height: 10),
                      ProfileButton(icon: Icons.list, title: getTranslated('terms_and_condition', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: false)));
                      }),
                      const SizedBox(height: 10),

                      ProfileButton(icon: Icons.logout, title: getTranslated('logout', context), onTap: () {
                        showDialog(context: context, barrierDismissible: false, builder: (context) => const SignOutConfirmationDialog());
                        
                      }),


                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _userInfoWidget({String? text, required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color:Colors.white,
          border: Border.all(color: const Color(0xFFDCDCDC)),
      ),
      child: Text(
        text ?? '',
        style:const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
