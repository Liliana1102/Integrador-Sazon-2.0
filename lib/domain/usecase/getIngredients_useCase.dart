import 'package:crud_movil/domain/repository/ingredientes.dart';

class GetIngredients {
  late final IngredientesRepository ingredientesRepository;
  GetIngredients(this.ingredientesRepository);

  Future<List<Map<String, String>>> getIngredients() async {
    return await ingredientesRepository.getIngredients();
  }


}
