import 'package:merchant/domain/data/models/store_model.dart';
import 'package:hive/hive.dart';
import 'package:merchant/constants/app_constants.dart';

import '../client/event_service.dart';

class StoreDB {
  StoreModel? currentStore() {
    final boxUser = Hive.box<StoreModel>(AppConstants.BOX_STORE);
    return boxUser.get(0);
  }

  Future<StoreModel> save(StoreModel storeModel) async {
    final boxUser = Hive.box<StoreModel>(AppConstants.BOX_STORE);
    await boxUser.put(0, storeModel);
    eventBus.fire(UpdateStoreEvent());
    return boxUser.get(0)!;
  }

  Future<void> clear() async {
    final boxUser = Hive.box<StoreModel>(AppConstants.BOX_STORE);
    await boxUser.delete(0);
    await boxUser.clear();
  }

  List<String> getSystem() {
    final boxUser = Hive.box<StoreModel>(AppConstants.BOX_STORE);
    return boxUser.get(0)?.system ?? ["1"];
  }
}
