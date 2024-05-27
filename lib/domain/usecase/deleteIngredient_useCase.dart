import 'package:crud_movil/domain/repository/ingredientes.dart';

class Deleteingredient {
  late final IngredientesRepository ingredientesRepository;
  Deleteingredient(this.ingredientesRepository);

  Future<void> deleteingredient(int index) async {
    await ingredientesRepository.deleteIngredient(index);
  }
}
