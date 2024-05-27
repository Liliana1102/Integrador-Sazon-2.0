import 'package:crud_movil/domain/repository/ingredientes.dart';

class AddIngredient {


  late final IngredientesRepository ingredientesRepository;
  AddIngredient(this.ingredientesRepository);


  Future<void> addIngredient(String name, String quantity) async {
    await ingredientesRepository.addIngredient(name, quantity);
  }
  
} 
