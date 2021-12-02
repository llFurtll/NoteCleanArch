abstract class IConfigRepository{
  Future<int?> updateImage({required String path_image});
  Future<String?> getImage();
  Future<int?> updateName({required String name});
  Future<String?> getName();
}