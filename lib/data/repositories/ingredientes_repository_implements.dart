// import 'package:crud_movil/data/datasources/ingredientes_api_data_source.dart';
// import 'package:crud_movil/domain/repository/ingredientes.dart';

// class IngredientesRepositoryImplements implements IngredientesRepository {
//   late final IngredientesApiDataSource ingredientesApiDataSource;


//   IngredientesRepositoryImplements(this.ingredientesApiDataSource);


//   @override
//   Future<void> addIngredient(String name, String quantity) async {}
  
//   @override
//   Future<void> editIngredient(int index, String name, String quantity)async {
//     await ingredientesApiDataSource.editIngredient(index, name, quantity);
//   }
//   @override
//   Future<List<Map<String, String>>> getIngredients() async {
//     return await ingredientesApiDataSource.getIngredients();
//   }
  
//   @override
//   Future<void> deleteIngredient(int index) async{
//    await ingredientesApiDataSource.deleteIngredient(index);
//   }
// }
