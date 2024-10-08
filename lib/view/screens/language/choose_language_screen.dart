import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/language_model.dart';
import 'package:resturant_delivery_boy/provider/language_provider.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
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
    bool isSelected = languageProvider.selectIndex == index;

    return InkWell(
      onTap: () {
        languageProvider.changeSelectIndex(index);
        Provider.of<LocalizationProvider>(context, listen: false).setLanguage(
          Locale(
            AppConstants.languages[languageProvider.selectIndex!].languageCode!,
            AppConstants.languages[languageProvider.selectIndex!].countryCode,
          ),
        );

        if (fromHomeScreen) {
          Navigator.pop(context);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
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
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
  color: Theme.of(context).textTheme.bodyMedium!.color,
  fontWeight: FontWeight.bold, 
),

                  ),
                ],
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? ColorResources.COLOR_PRIMARY: Colors.grey),
                ),
                child: Center(
                  child: isSelected
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: ColorResources.COLOR_PRIMARY,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
