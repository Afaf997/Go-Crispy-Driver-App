import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/helper/email_checker.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/base/custom_snackbar.dart';
import 'package:resturant_delivery_boy/view/base/custom_text_field.dart';
import 'package:resturant_delivery_boy/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail();
    _passwordController!.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: ColorResources.COLOR_WHITE,
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    Images.logo,
                    height: MediaQuery.of(context).size.height / 4.5,
                    fit: BoxFit.scaleDown,
                    matchTextDirection: true,
                  ),
                ),
                Center(
                  child: Text(
                    getTranslated('login', context)!,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 24, 
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  getTranslated('email_address', context)!,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                CustomTextField(
                  hintText: getTranslated('Email Id', context),
                  isShowBorder: true,
                  focusNode: _emailFocus,
                  nextFocus: _passwordFocus,
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(
                  getTranslated('password', context)!,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                CustomTextField(
                  hintText: getTranslated('Password', context),
                  isShowBorder: true,
                  isPassword: true,
                  isShowSuffixIcon: true,
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  inputAction: TextInputAction.done,
                ),
                const SizedBox(height: 22),

                // Remember me section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => InkWell(
                        onTap: () {
                          authProvider.toggleRememberMe();
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: authProvider.isActiveRememberMe
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).canvasColor,
                                border: Border.all(
                                  color: authProvider.isActiveRememberMe
                                      ? Colors.transparent
                                      : Theme.of(context).highlightColor,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: authProvider.isActiveRememberMe
                                  ? const Icon(Icons.done, color: Colors.white, size: 17)
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(
                              getTranslated('remember_me', context)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                !authProvider.isLoading
                    ? CustomButton(
                        btnTxt: getTranslated('login', context),
                        onTap: () async {
                          String email = _emailController!.text.trim();
                          String password = _passwordController!.text.trim();
                          if (email.isEmpty) {
                            showCustomNotification(context, getTranslated('enter_email_address', context)!, type: NotificationType.warning);
                          } else if (EmailChecker.isNotValid(email)) {
                            showCustomNotification(context, getTranslated('enter_valid_email', context)!, type: NotificationType.warning);
                          } else if (password.isEmpty) {
                            showCustomNotification(context, getTranslated('enter_password', context)!, type: NotificationType.warning);
                          } else if (password.length < 6) {
                            showCustomNotification(context, getTranslated('password_should_be', context)!, type: NotificationType.warning);
                          } else {
                            await authProvider.login(emailAddress: email, password: password).then((status) async {
                              if (status.isSuccess) {
                                if (authProvider.isActiveRememberMe) {
                                  authProvider.saveUserNumberAndPassword(email, password);
                                } else {
                                  authProvider.clearUserEmailAndPassword();
                                }
                                await Navigator.of(Get.context!).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                );
                              } else if (authProvider.loginErrorMessage!.isNotEmpty) {
                                showCustomNotification(
                                  context,
                                  getTranslated('Invalid email or password. Please try again.', context)!,
                                  type: NotificationType.error,
                                );
                              }
                            });
                          }
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
                        ),
                      ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
