import 'package:hive/hive.dart';
import 'package:merchant/constants/app_constants.dart';

import '../client/event_service.dart';
import '../data/models/user_model.dart';

class UserDB {
  UserModel? currentUser() {
    final boxUser = Hive.box<UserModel>(AppConstants.BOX_USER);
    return boxUser.get(0);
  }

  Future<UserModel> save(UserModel userModel) async {
    final boxUser = Hive.box<UserModel>(AppConstants.BOX_USER);
    await boxUser.put(0, userModel);
    eventBus.fire(UserEvent());
    return boxUser.get(0)!;
  }

  Future<void> clear() async {
    final boxUser = Hive.box<UserModel>(AppConstants.BOX_USER);
    await boxUser.delete(0);
    await boxUser.clear();
  }
}
