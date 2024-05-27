import 'package:crud_movil/domain/entities/ingredientes.dart';

class PrincipalModels extends Principal{
  PrincipalModels(super.ingrediente, super.cantidad);

  factory PrincipalModels.fromJson(Map<String, dynamic> json) {
    return PrincipalModels(
      json['ingrediente'],
      json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingrediente': ingrediente,
      'cantidad': cantidad,
    };
  }
}