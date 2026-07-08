import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/widgets/app_text_field.dart';
import '../../../../common/design/src/widgets/my_custom_widget/back_widget.dart';
import '../../../../common/design/src/widgets/my_custom_widget/my_custom_scaffold.dart';
import '../../../../common/design/src/widgets/phone_number_widget/my_phone_number_field_widget.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/extensions/src/validation.dart';
import '../../../../common/helper/src/app_varibles.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/use_cases/user_update_me_use_cases.dart';
import '../bloc/user_bloc.dart';

class PersonalInformationScreen extends StatefulWidget {
  final PersonalInformationParams arg;

  const PersonalInformationScreen({super.key, required this.arg});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final GlobalKey<FormState> _globalKey;
  late final UserBloc userBloc;
  late final ValueNotifier<String> phoneFieldValue;
  late final ValueNotifier<bool> valueNotifier;
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  @override
  void initState() {
    final nameParts = _splitName(AppVariables.user?.firstName ?? '');
    firstNameController = TextEditingController(text: nameParts.$1);
    lastNameController = TextEditingController(text: nameParts.$2);
    _globalKey = GlobalKey<FormState>();
    valueNotifier = ValueNotifier(false);
    phoneFieldValue = ValueNotifier(AppVariables.user?.phone?.toString() ?? '');
    userBloc = widget.arg.userBloc;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    phoneFocus.dispose();
    valueNotifier.dispose();
    phoneFieldValue.dispose();
    super.dispose();
  }

  (String, String) _splitName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return ('', '');
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: userBloc,
      listenWhen: (pre, next) =>
          pre.updateMeData.status != next.updateMeData.status,
      listener: (context, state) {
        state.updateMeData.listenerFunction(onSuccess: () {
          context.pop();
        });
      },
      builder: (context, state) {
        return MyCustomScaffold(
          top: 10,
          body: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (context, value, _) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          BackWidget(),
                          const SizedBox(width: 8),
                          Text(
                            LocaleKeys.profilePersonalInformation.tr(),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          const Spacer(),
                          CustomEditButtonIcon(
                            svg: value
                                ? Assets.images.svg.profile.checkIcon
                                : Assets.images.svg.profile.editIcon,
                            onTap: () {
                              if (valueNotifier.value) {
                                if (!(_globalKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }
                                userBloc.add(
                                  UserUpdateMeEvent(
                                    params: UserUpdateMeParams(
                                      firstName: firstNameController.text.trim(),
                                      lastName: lastNameController.text.trim(),
                                      phone: phoneFieldValue.value,
                                    ),
                                  ),
                                );
                              } else {
                                valueNotifier.value = true;
                              }
                            },
                            color: value ? AppColors.primary : Colors.white,
                            svgColor: value ? Colors.white : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 38),
                      MyAppTextField(
                        isPadding: false,
                        labelText: LocaleKeys.profileFirstNameEdit.tr(),
                        controller: firstNameController,
                        validator: (text) => text.isNotShortText,
                        keyboardType: TextInputType.name,
                        enabled: value,
                        focus: firstNameFocus,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(lastNameFocus);
                        },
                      ),
                      const SizedBox(height: 16),
                      MyAppTextField(
                        isPadding: false,
                        labelText: LocaleKeys.profileLastNameEdit.tr(),
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        enabled: value,
                        focus: lastNameFocus,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(phoneFocus);
                        },
                      ),
                      const SizedBox(height: 16),
                      MyPhoneNumberField(
                        labelText: LocaleKeys.authEnterPhone.tr(),
                        isMargin: false,
                        readOnly: !value,
                        internationalPhoneValue: phoneFieldValue,
                        focusNode: phoneFocus,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class PersonalInformationParams {
  final UserBloc userBloc;

  PersonalInformationParams({required this.userBloc});
}
