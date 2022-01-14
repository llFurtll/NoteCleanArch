abstract class IConfigRepository{
  Future<int?> updateImage({required String pathImage});
  Future<String?> getImage();
  Future<int?> updateName({required String name});
  Future<String?> getName();
}