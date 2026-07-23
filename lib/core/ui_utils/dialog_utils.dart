import 'package:chat_app/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading({required BuildContext context,required String loadingText}){
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: AppColors.primaryColor,),
            Text(loadingText,style: Theme.of(context).textTheme.bodyLarge,)
          ],
        ),
      ),
    );
  }
  static void removeLoading({required BuildContext context}){
    Navigator.pop(context);
  }
  static void showMessage({required BuildContext context,String? title,required String message,String? posActionName,Function? posAction,String? negActionName,Function? negAction}){
    List<Widget>? actions=[];
    if(posActionName!=null){
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          posAction?.call();
        }, 
        child: Text(posActionName,style: Theme.of(context).textTheme.bodyMedium,)
      )
      );
    }
    if(negActionName!=null){
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          negAction?.call();
        }, 
        child: Text(negActionName,style: Theme.of(context).textTheme.bodyMedium,)
      )
      );
    }
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(title?? '',style: Theme.of(context).textTheme.titleMedium,),
        content: Text(message,style: Theme.of(context).textTheme.bodyLarge,),
        actions: actions,
      ),
    );
  }
}