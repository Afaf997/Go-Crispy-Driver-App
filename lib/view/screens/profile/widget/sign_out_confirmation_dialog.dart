import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/view/screens/auth/login_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor:Colors.white,
              child: Icon(Icons.contact_support, size: 50, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Text(getTranslated('want_to_sign_out', context)!, style: rubikRegular, textAlign: TextAlign.center),
            ),

            Divider(height: 0, color: Theme.of(context).hintColor),

            !auth.isLoading ? Row(children: [

              Expanded(child: InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  await Provider.of<AuthProvider>(context, listen: false).clearSharedData();
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('yes', context)!, style: rubikBold.copyWith(color: ColorResources.COLOR_PRIMARY)),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration:const BoxDecoration(
                    color: ColorResources.COLOR_PRIMARY,
                    borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10)),
                  ),
                  child: Text(getTranslated('no', context)!, style: rubikBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) : const Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY)),
            ),
          ]);
        }),
      ),
    );
  }
}