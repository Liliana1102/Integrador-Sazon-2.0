import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crud_movil/data/datasources/ingredientes_api_data_source.dart';
import 'package:crud_movil/presentation/pages/connectiviti.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final ItemsController itemsController = Get.put(ItemsController());
  final ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  @override
  void initState() {
    super.initState();
    itemsController.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('                     SAZZON  🧂🥗'),
        backgroundColor: const Color(0xFFBADF70),
      ),
      body: Column(
        children: [
          Obx(() {
            return Container(
              color: connectivityController.isOnline.value
                  ? Colors.green
                  : Colors.red,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    connectivityController.isOnline.value
                        ? 'Conectado a Internet'
                        : 'Sin conexión a Internet',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ingrediente',
                      fillColor: Color.fromARGB(255, 250, 255, 200),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      fillColor: Color.fromARGB(255, 250, 255, 200),
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFDF8F70)),
                  onPressed: () {
                    final name = nameController.text;
                    final quantity = quantityController.text;
                    if (name.isNotEmpty && quantity.isNotEmpty) {
                      itemsController.addIngredient(name, quantity);
                      nameController.clear();
                      quantityController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: itemsController.ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = itemsController.ingredients[index];
                  return ListTile(
                    title: Text('${ingredient['ingrediente']}'),
                    subtitle: Text('Cantidad: ${ingredient['cantidad']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFFDF8F70)),
                          onPressed: () {
                            var selectedId = ingredient['id'];
                            nameController.text = ingredient['ingrediente']!;
                            quantityController.text = ingredient['cantidad']!;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Editar'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre del Ingrediente',
                                        filled: true,
                                      ),
                                    ),
                                    TextField(
                                      controller: quantityController,
                                      decoration: const InputDecoration(
                                        labelText: 'Cantidad',
                                        filled: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      final newName = nameController.text;
                                      final newQuantity = quantityController.text;
                                      if (newName.isNotEmpty && newQuantity.isNotEmpty) {
                                        itemsController.editIngredient(index, newName, newQuantity);
                                        nameController.clear();
                                        quantityController.clear();
                                        itemsController.loadData(); // Recargar la lista
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Guardar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFFDF8F70)),
                          onPressed: () {
                            print('Eliminar ID: ${ingredient['id']}');
                            itemsController.deleteIngredient(index);
                            itemsController.loadData(); // Recargar la lista
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
