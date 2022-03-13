import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';

Future<bool> login() async {
  const android = AndroidAuthMessages(
    biometricRequiredTitle: "Required Title",
    deviceCredentialsRequiredTitle: "credencials title",
    goToSettingsButton: "settings",
    goToSettingsDescription: "settigs description",
    deviceCredentialsSetupDescription: "credential setup",
    signInTitle: "😳",
  );
  var localAuth = LocalAuthentication();
  bool didAuthenticate = await localAuth.authenticate(
    androidAuthStrings: android,
    localizedReason: 'Necesitamos tu huella para darte acceso',
    stickyAuth: false,
  );
  return didAuthenticate;
}
