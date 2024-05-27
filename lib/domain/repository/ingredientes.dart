abstract class IngredientesRepository {
  // se debe de asignar un delete, get list, post , put
  
  Future<void> addIngredient(String name, String quantity);
  Future<void> editIngredient(int index, String name, String quantity);
  Future<void> deleteIngredient(int index);
  Future<List<Map<String, String>>> getIngredients();
}
