import 'package:crud_movil/data/datasources/ingredientes_api_data_source.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConnectivityController extends GetxController {
  var isOnline = false.obs;
  final ItemsController itemsController = Get.find();
  var pendingOperations = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPendingOperations();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResults = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResults);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      isOnline.value = false;
    } else {
      isOnline.value = true;
      _syncPendingOperations();
    }
  }

Future<void> _syncPendingOperations() async {
  final prefs = await SharedPreferences.getInstance();
  final operations = prefs.getString('offlineOperations');
  if (operations != null) {
    final List<dynamic> ops = jsonDecode(operations);
    for (var op in ops) {
      switch (op['type']) {
        case 'add':
          await itemsController.sendAddRequest(Map<String, dynamic>.from(op['data']));
          break;
        case 'edit':
          // Convert the data to Map<String, String>
          Map<String, String> data = op['data'].map<String, String>((key, value) {
            return MapEntry(key.toString(), value.toString());
          }).cast<String, String>();
          await itemsController.sendEditRequest(op['data']['id'], data);
          break;
        case 'delete':
          await itemsController.sendDeleteRequest(op['data']['id']);
          break;
      }
    }
    prefs.remove('offlineOperations');
  }
}




  Future<void> _loadPendingOperations() async {
    final prefs = await SharedPreferences.getInstance();
    final operations = prefs.getString('offlineOperations');
    if (operations != null) {
      pendingOperations.value =
          List<Map<String, dynamic>>.from(jsonDecode(operations));
    }
  }
}
