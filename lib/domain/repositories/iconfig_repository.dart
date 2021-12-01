import 'package:note/data/model/config_model.dart';

abstract class IConfigRepository{
  Future<int?> insertImage();
  Future<int?> updateImage({required int id});
  Future<String?> getImage({required int id});
  Future<int?> insertName({required String text});
  Future<int?> updateName({required String text});
  Future<String?> getName({required int id});
}