import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';

Future<bool> canUseBiometrics() async {
  final LocalAuthentication auth = LocalAuthentication();
  if (!await auth.canCheckBiometrics) return false;

  final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
  if (availableBiometrics.isEmpty) return false;
  return true;
}

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
