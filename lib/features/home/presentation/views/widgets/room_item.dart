import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:flutter/material.dart';

class RoomItem extends StatelessWidget {
  final RoomEntity room;
  const RoomItem({super.key,required this.room});

  @override
  Widget build(BuildContext context) {
    final category = CategoryEntity.getCategoryById(room.categoryId);
    final iconData = category?.iconData ?? Icons.help_outline;
    var width=MediaQuery.sizeOf(context).width;
    var height=MediaQuery.sizeOf(context).height;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.chat,arguments: {
          'roomId':room.id,
          'roomName':room.name
        });
      },
      child: Container(
        height: 0.5*height,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(0.05*width),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor,
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ]
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Center(
                child: Icon(iconData,size: 72,color: AppColors.primaryColor,),
              ),
            ),
            SizedBox(height: 0.01*height,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.04*width),
              child: Column(
                children: [
                  Text(room.name,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 16
                  ),maxLines: 3,textAlign: TextAlign.center,),
                  SizedBox(height: 0.01*height,),
                  Text(room.description,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyColor,
                    overflow: TextOverflow.ellipsis
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}