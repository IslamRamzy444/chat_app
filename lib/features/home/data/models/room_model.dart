import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  final String? id;
  final String name;
  final String description;
  final String categoryId;
  final DateTime? createdAt;
  RoomModel({this.id,required this.name,required this.description,required this.categoryId,this.createdAt});
  factory RoomModel.fromJson(Map<String,dynamic> json){
    return RoomModel(
      id: json['id'],
      name: json['name'], 
      description: json['description'], 
      categoryId: json['categoryId'],
      createdAt: json['createdAt'] != null? (json['createdAt'] as Timestamp).toDate(): null,
    );
  }
  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'name':name,
      'description':description,
      'categoryId':categoryId
    };
  }
  RoomEntity toEntity(){
    return RoomEntity(
      id: id,
      name: name, 
      description: description, 
      categoryId: categoryId,
      createdAt: createdAt
    );
  }
}