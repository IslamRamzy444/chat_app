class RoomEntity {
  final String? id;
  final String name;
  final String description;
  final String categoryId;
  final DateTime? createdAt;
  RoomEntity({this.id,required this.name,required this.description,required this.categoryId,this.createdAt});
}