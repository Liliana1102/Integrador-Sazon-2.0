import 'package:crud_movil/domain/repository/ingredientes.dart';

class EditIngredient {
  late final IngredientesRepository ingredientesRepository;
  EditIngredient(this.ingredientesRepository);

  Future<void> editIngredient(int index, String name, String quantity) async {
    await ingredientesRepository.editIngredient(index, name, quantity);
  }
}
