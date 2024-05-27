import 'package:crud_movil/presentation/pages/connectiviti.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemsController extends GetxController {
  var ingredients = <Map<String, dynamic>>[].obs;

  void addIngredient(String name, String quantity) async {
    var newIngredient = {'id': null, 'ingrediente': name, 'cantidad': quantity};
    ingredients.add(newIngredient);
    await _saveData();
    if (Get.find<ConnectivityController>().isOnline.value) {
      await sendAddRequest(newIngredient);
    } else {
      await _saveOperation('add', {'ingrediente': name, 'cantidad': quantity});
    }
  }

  void editIngredient(int index, String name, String quantity) async {
    var ingredient = ingredients[index];
    if (ingredient['id'] == null) {
      print('No se puede editar el ingrediente sin ID');
      return;
    }
    ingredient['ingrediente'] = name;
    ingredient['cantidad'] = quantity;
    await _saveData();
    if (Get.find<ConnectivityController>().isOnline.value) {
      await sendEditRequest(ingredient['id'], {'ingrediente': name, 'cantidad': quantity});
    } else {
      await _saveOperation('edit', {'id': ingredient['id'], 'ingrediente': name, 'cantidad': quantity});
    }
  }

  void deleteIngredient(int index) async {
    var ingredient = ingredients[index];
    if (ingredient['id'] == null) {
      print('No se puede eliminar el ingrediente sin ID');
      return;
    }
    ingredients.removeAt(index);
    await _saveData();
    if (Get.find<ConnectivityController>().isOnline.value) {
      await sendDeleteRequest(ingredient['id']);
    } else {
      await _saveOperation('delete', {'id': ingredient['id']});
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(ingredients);
    prefs.setString('offlineData', data);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('offlineData');
    if (data != null) {
      ingredients.value = List<Map<String, dynamic>>.from(jsonDecode(data));
    }

    if (Get.find<ConnectivityController>().isOnline.value) {
      await _fetchIngredientsFromAPI();
    }
  }

  Future<void> _fetchIngredientsFromAPI() async {
    final url = Uri.parse('http://10.0.2.2:3001/api/v1/ingredientes/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      ingredients.value = data
          .map((item) => {
                'id': item['id'],
                'ingrediente': item['ingrediente'] as String,
                'cantidad': item['cantidad'].toString(),
              })
          .toList();
      await _saveData();
    } else {
      print('Error fetching ingredients from server');
      print('Código de estado: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
    }
  }

  Future<void> _saveOperation(String type, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final operations = prefs.getString('offlineOperations');
    List<dynamic> ops = operations != null ? jsonDecode(operations) : [];
    ops.add({'type': type, 'data': data});
    prefs.setString('offlineOperations', jsonEncode(ops));
  }

  Future<void> sendAddRequest(Map<String, dynamic> newIngredient) async {
    final url = Uri.parse('http://10.0.2.2:3001/api/v1/ingredientes/');
    final response = await http.post(url,
        body: jsonEncode({
          'ingrediente': newIngredient['ingrediente'],
          'cantidad': newIngredient['cantidad']
        }),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 201 || response.statusCode == 200) {
      var addedIngredient = jsonDecode(response.body);
      int index = ingredients.indexOf(newIngredient);
      if (index != -1) {
        ingredients[index]['id'] = addedIngredient['id'];
        await _saveData();
      }
      print('Ingrediente agregado al servidor: $addedIngredient');
    } else {
      print('Error al agregar ingrediente al servidor');
      print('Código de estado: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
    }
  }

  Future<void> sendEditRequest(int? id, Map<String, String> editedIngredient) async {
    if (id == null) {
      print('No se puede editar el ingrediente sin ID');
      return;
    }
    final url = Uri.parse('http://10.0.2.2:3001/api/v1/ingredientes/$id');
    final response = await http.put(url,
        body: jsonEncode(editedIngredient),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print('Ingrediente editado en el servidor: $editedIngredient');
    } else {
      print('Error al editar ingrediente en el servidor');
      print('Código de estado: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
    }
  }

  Future<void> sendDeleteRequest(int? id) async {
    if (id == null) {
      print('No se puede eliminar el ingrediente sin ID');
      return;
    }
    final url = Uri.parse('http://10.0.2.2:3001/api/v1/ingredientes/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print('Ingrediente eliminado del servidor: $id');
    } else {
      print('Error al eliminar ingrediente del servidor');
      print('Código de estado: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
    }
  }
}
