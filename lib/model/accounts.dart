import 'package:hive/hive.dart';

part 'accounts.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  late String app;
  @HiveField(1)
  late String email;
  @HiveField(2)
  late String password;
  @HiveField(3)
  late bool isFromAssets;
  @HiveField(4)
  late String imagePath;

  Account fromJson(Map<String, dynamic> json) => Account()
    ..app = json['app']
    ..email = json['email']
    ..password = json['password']
    ..isFromAssets = json['isFromAssets']
    ..imagePath = json['imagePath'];

  Map<String, dynamic> toJson() => {
        'app': app,
        'email': email,
        'password': password,
        'isFromAssets': isFromAssets,
        'imagePath': imagePath,
      };
}
