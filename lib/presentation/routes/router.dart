import 'package:auto_route/auto_route_annotations.dart';
import 'package:resocoder_ddd_tutorial/presentation/splash/splash_page.dart';

import '../sign_in/sign_in_page.dart';

@MaterialAutoRouter(
    generateNavigationHelperExtension: true,
    routes: <AutoRoute>[
      MaterialRoute(page: SplashPage, initial: true),
      MaterialRoute(page: SignInPage),
    ])
class $Router {}
