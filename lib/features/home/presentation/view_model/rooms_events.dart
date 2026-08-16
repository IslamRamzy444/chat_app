import 'package:chat_app/features/home/domain/entities/category_entity.dart';

sealed class RoomsEvents {}
class GetRoomsEvent extends RoomsEvents{}
class CreateRoomEvent extends RoomsEvents{
  final String name;
  final String description;
  final String categoryId;
  CreateRoomEvent({
    required this.name,
    required this.description,
    required this.categoryId
  });
}
class SelectCategoryEvent extends RoomsEvents{
  final CategoryEntity category;
  SelectCategoryEvent(this.category);
}