import 'package:client/configs/configs.dart';
import 'package:client/ui/painter/icons/email.dart';
import 'package:client/ui/painter/icons/lock.dart';
import 'package:client/ui/painter/icons/person_broken.dart';
import 'package:client/ui/painter/icons/person_circle.dart';
import 'package:client/ui/painter/icons/person_filled.dart';
import 'package:client/ui/painter/icons/person_outline.dart';
import 'package:client/ui/widgets/core/screen/screen.dart';
import 'package:client/ui/widgets/design/button/button.dart';
import 'package:client/ui/widgets/design/buttons/app_back_button.dart';
import 'package:client/ui/widgets/design/input/app_input_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

part 'static/_form_data.dart';
part 'static/_form_keys.dart';

part 'widgets/_body.dart';

part '_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}
