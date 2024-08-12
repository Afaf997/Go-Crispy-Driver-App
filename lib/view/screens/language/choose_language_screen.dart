import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/language_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/language_provider.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/base/custom_snackbar.dart';
import 'package:resturant_delivery_boy/view/screens/auth/login_screen.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromHomeScreen;

  const ChooseLanguageScreen({Key? key, this.fromHomeScreen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);

    return Scaffold(
      backgroundColor: ColorResources.COLOR_PRIMARY,
      appBar: null, // No app bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: Image.asset(
            Images.logo,
            width: 117,
            height: 160,
          ),
        ),
      ),
      bottomSheet: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          height: 250,
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) => Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: languageProvider.languages.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => _languageWidget(
                      context: context,
                      languageModel: languageProvider.languages[index],
                      languageProvider: languageProvider,
                      index: index,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.COLOR_PRIMARY,
                    foregroundColor: Colors.white, // Set the text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if (languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                      Provider.of<LocalizationProvider>(context, listen: false).setLanguage(
                        Locale(
                          AppConstants.languages[languageProvider.selectIndex!].languageCode!,
                          AppConstants.languages[languageProvider.selectIndex!].countryCode,
                        ),
                      );
                      if (fromHomeScreen) {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      }
                    } else {
                      showCustomSnackBar(getTranslated('select_a_language', context)!);
                    }
                  },
                  child: SizedBox(
                    width: double.infinity, // Full width button
                    child: Center(
                      child: Text(getTranslated('save', context)!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageWidget({
    required BuildContext context,
    required LanguageModel languageModel,
    required LanguageProvider languageProvider,
    int? index,
  }) {
    return InkWell(
      onTap: () {
        languageProvider.changeSelectIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    languageModel.languageName!,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                  ),
                ],
              ),
              languageProvider.selectIndex == index
                  ? Image.asset(
                      Images.done,
                      width: 17,
                      height: 17,
                      color: ColorResources.COLOR_PRIMARY,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
