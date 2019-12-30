import 'package:get_it/get_it.dart';
import 'package:peer_learning/models/AppModel.dart';
import 'package:peer_learning/models/LoginModel.dart';
import 'package:peer_learning/models/SignUpModel.dart';
import 'package:peer_learning/models/chat_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //Register Services

  //Register Models
  locator.registerFactory<AppModel>(() => AppModel());
  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<SignUpModel>(() => SignUpModel());
  locator.registerFactory<ChatModel>(() => ChatModel());
}
