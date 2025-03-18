import 'package:async_button_builder/async_button_builder.dart';
import 'package:controller/routes/settings_routes.dart';
import 'package:controller/src/widgets/toast_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:controller/src/controllers/auth/auth_controller.dart';
import 'package:controller/src/widgets/backround_blur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<String> _tapSequence = [];
  Timer? _sequenceTimer;

  @override
  void initState() {
    super.initState();
    _loadDataUser();
  }

  @override
  void dispose() {
    _sequenceTimer?.cancel();
    super.dispose();
  }

  void _loadDataUser() {
    var authController = context.read<AuthController>();
    _nameController.text = authController.userInfo!.name!;
    _emailController.text = authController.userInfo!.email!;
    setState(() {});
  }

  void _checkEasterEgg() {
    const expectedSequence = [
      'email',
      'email',
      'email',
      'password',
      'password',
      'email'
    ];

    if (_tapSequence.length > expectedSequence.length) {
      _resetSequence();
      return;
    }

    if (listEquals(_tapSequence, expectedSequence)) {
      ToastService.showSuccess(context, 'Easter egg unlocked 🎉 - By Martifu');
      _resetSequence();
    }

    _sequenceTimer?.cancel();
    _sequenceTimer = Timer(const Duration(seconds: 2), _resetSequence);
  }

  void _resetSequence() {
    setState(() {
      _tapSequence = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var authController = context.read<AuthController>();

    return BackgroundBlur(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.profile),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: [
              AsyncButtonBuilder(
                loadingWidget: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 3,
                  ),
                ),
                successWidget:
                    Icon(Icons.check, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await authController.changeName(
                      _nameController.text, context);
                },
                builder: (context, child, callback, _) {
                  return TextButton(
                    onPressed: callback,
                    child: child,
                  );
                },
                child: Text(AppLocalizations.of(context)!.save,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(.1),
                      child: const Icon(Icons.person,
                          size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.name,
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enterUsername,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9._-]')),
                    ],
                    validator: (value) {
                      // Validar que contenga solo los caracteres permitidos
                      var regExp = RegExp(r'^[a-zA-Z0-9._-]+$');
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .enterUsernameValidation;
                      }
                      if (!regExp.hasMatch(value)) {
                        return AppLocalizations.of(context)!
                            .enterNameValidation;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.email,
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      print('email');
                      setState(() {
                        _tapSequence.add('email');
                        _checkEasterEgg();
                      });
                    },
                    child: TextField(
                      controller: _emailController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: '',
                        suffixIcon: Icon(Icons.lock,
                            color: Colors.grey.withOpacity(.5), size: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.password,
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      print('password');
                      setState(() {
                        _tapSequence.add('password');
                        _checkEasterEgg();
                      });
                    },
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: '********',
                        suffixIcon: Icon(Icons.lock,
                            color: Colors.grey.withOpacity(.5), size: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/account/change-password');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.changePassword,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          Navigator.of(context)
                              .pushNamed(SettingsRoutes.deleteAccount);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
