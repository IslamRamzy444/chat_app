import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSentByMe;
  const MessageBubble({super.key,required this.message,required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat('HH:mm').format(message.dateTime);
    var width=MediaQuery.sizeOf(context).width;
    var height=MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if(!isSentByMe)
        Padding(
          padding: EdgeInsets.only(bottom: 0.01*height,left: 0.03*width),
          child: Text(message.senderName,style: Theme.of(context).textTheme.bodyMedium,),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if(isSentByMe) ...[
              Padding(
                padding: EdgeInsets.only(right: 0.02*width),
                child: Text(timeFormatted,style: Theme.of(context).textTheme.bodyMedium,),
              ),
              _buildMessageContainer(context)
            ]else ...[
              _buildMessageContainer(context),
              Padding(
                padding: EdgeInsets.only(left: 0.02*width),
                child: Text(timeFormatted,style: Theme.of(context).textTheme.bodyMedium,),
              )
            ]
          ],
        )
      ],
    );
  }
  Widget _buildMessageContainer(BuildContext context){
    var width=MediaQuery.sizeOf(context).width;
    var height=MediaQuery.sizeOf(context).height;
    return Container(
      constraints: BoxConstraints(
        maxWidth: 0.7*width,
      ),
      padding: EdgeInsets.symmetric(horizontal: 0.03*width,vertical: 0.01*height),
      decoration: BoxDecoration(
        color: isSentByMe?AppColors.primaryColor:AppColors.whiteColor,
        borderRadius: isSentByMe?
        BorderRadius.only(topLeft: Radius.circular(0.05*width),topRight: Radius.circular(0.05*width),bottomRight: Radius.circular(0.05*width)):
        BorderRadius.only(topLeft: Radius.circular(0.05*width,),topRight: Radius.circular(0.05*width),bottomLeft: Radius.circular(0.05*width)),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor,
            blurRadius: 4,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: Text(message.content,style: isSentByMe?Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16):Theme.of(context).textTheme.bodyMedium,),
    );
  }
}