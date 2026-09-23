import 'package:chat_app/config/di/di.dart';
import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_events.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_states.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_view_model.dart';
import 'package:chat_app/features/chat/presentation/views/widgets/message_bubble.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ChatViewModel viewModel=getIt<ChatViewModel>();
  late Map<String,dynamic> args;
  late String roomId;
  late String roomName;
  @override
  void initState() {
    super.initState();
    viewModel.doIntent(LoadCurrentUserEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args=ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
      roomId=args['roomId'];
      roomName=args['roomName'];
      viewModel.doIntent(LoadMessagesEvent(roomId));
    },);
  }
  @override
  Widget build(BuildContext context) {
    args=ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    roomId=args['roomId'];
    roomName=args['roomName'];
    var width=MediaQuery.sizeOf(context).width;
    var height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName,style: Theme.of(context).textTheme.headlineMedium,),
      ),
      body: BlocProvider<ChatViewModel>(
        create: (context) => viewModel,
        child: BlocBuilder<ChatViewModel,ChatStates>(
          builder: (context, state) {
            final messagesState = state.messagesState;
            final messages = messagesState?.data ?? [];
            final currentUserState = state.currentUserState;
            final currentUser = currentUserState?.data;
            if(currentUserState?.isLoading==true){
              return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
            }
            if(currentUserState?.errorMessage!=null){
              return Center(child: Text(currentUserState!.errorMessage!,style: Theme.of(context).textTheme.bodyLarge,),);
            }
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty?Center(child: Text(AppLocalizations.of(context)!.no_messages,style: Theme.of(context).textTheme.bodyLarge,),):
                  ListView.separated(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 0.04*width,vertical: 0.01*height),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(
                        message: message, 
                        isSentByMe: message.senderId == currentUser?.id
                      );
                    }, 
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 0.01*height,);
                    }, 
                    itemCount: messages.length
                  )
                ),
                Container(
                  padding: EdgeInsets.all(0.04*width),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: AppColors.greyColor.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          maxLines: 4,
                          onChanged: (value) {
                            viewModel.doIntent(UpdateMessageTextEvent(value));
                          },
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.type_message
                          ),
                        )
                      ),
                      SizedBox(width: 0.02*width,),
                      BlocBuilder<ChatViewModel,ChatStates>(
                        builder: (context, state) {
                          final isEmpty = state.messageText.trim().isEmpty;
                          final isLoading = state.sendMessageState?.isLoading == true;
                          return ElevatedButton(
                            onPressed: (isEmpty || isLoading || currentUser == null)?null:
                            (){
                              final text = messageController.text;
                              viewModel.doIntent(SendMessageEvent(content: text, roomId: roomId));
                              messageController.clear();
                            }, 
                            child: isLoading?const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: AppColors.whiteColor,),
                            ):Row(
                              children: [
                                Icon(Icons.send,color: AppColors.whiteColor,),
                                Text(AppLocalizations.of(context)!.send)
                              ],
                            )
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}