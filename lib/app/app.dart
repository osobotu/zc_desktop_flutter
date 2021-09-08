import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:zc_desktop_flutter/services/local_storage/local_storage_service.dart';
import 'package:zc_desktop_flutter/ui/auth/auth_input/auth_input.dart';
import 'package:zc_desktop_flutter/ui/auth/check_mail_page/check_email_view.dart';
import 'package:zc_desktop_flutter/ui/auth/forgot_password_page/forgot_password_view.dart';
import 'package:zc_desktop_flutter/ui/auth/login_page/login_view.dart';
import 'package:zc_desktop_flutter/ui/auth/sign_up_page/sign_up_view.dart';
import 'package:zc_desktop_flutter/ui/main/home_page/home_view.dart';
import 'package:zc_desktop_flutter/ui/startup_page/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: AuthInput),
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: StartUpView),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: ForgotPasswordView),
    MaterialRoute(page: CheckEmailView),
  ],
  dependencies: [
    Presolve(
      classType: LocalStorageService,
      presolveUsing: LocalStorageService.getInstance,
    ),
    LazySingleton(classType: NavigationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
