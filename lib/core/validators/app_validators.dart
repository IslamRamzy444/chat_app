import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppValidators {
  AppValidators._();
  static String? validateEmail(String? val,BuildContext context){
    RegExp emailRegex=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if(val==null || val.trim().isEmpty){
      return AppLocalizations.of(context)!.required_field;
    }else if(emailRegex.hasMatch(val.trim())==false){
      return AppLocalizations.of(context)!.valid_email;
    }else{
      return null;
    }
  }
  static String? validatePassword(String? val,BuildContext context){
    RegExp passwordRegex=RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])');
    if(val==null || val.trim().isEmpty){
      return AppLocalizations.of(context)!.required_field;
    }else if(val.length<8 || passwordRegex.hasMatch(val.trim())==false){
      return AppLocalizations.of(context)!.valid_password;
    }else{
      return null;
    }
  }
  static String? validateConfirmPassword(String? val,String? password,BuildContext context){
    if(val==null || val.trim().isEmpty){
      return AppLocalizations.of(context)!.required_field;
    }else if(val.trim()!=password?.trim()){
      return AppLocalizations.of(context)!.passwords_mismatch;
    }else{
      return null;
    }
  }
  static String? validateUserName(String? val,BuildContext context){
    RegExp userNameRegex=RegExp(r'^[a-zA-Z0-9,.-]+$');
    if(val==null || val.trim().isEmpty){
      return AppLocalizations.of(context)!.required_field;
    }else if(!userNameRegex.hasMatch(val.trim())){
      return AppLocalizations.of(context)!.valid_user_name;
    }else{
      return null;
    }
  }
  static String? validateRoomName(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.required_field;
    }
    final trimmed = val.trim();
    if (trimmed.length < 3) {
      return AppLocalizations.of(context)!.room_name_length;
    }
    final firstChar = trimmed[0];
    if (!RegExp(r'^[a-zA-Z]').hasMatch(firstChar)) {
      return AppLocalizations.of(context)!.room_name_start_with_letter;
    }
    return null;
  }
  static String? validateDescription(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.required_field;
    }
    final trimmed = val.trim();
    if (trimmed.length < 3) {
      return AppLocalizations.of(context)!.description_min_length;
    }
    final firstChar = trimmed[0];
    if (!RegExp(r'^[a-zA-Z]').hasMatch(firstChar)) {
      return AppLocalizations.of(context)!.description_start_with_letter;
    }
    return null;
  }
  static String? validateCategory(CategoryEntity? category, BuildContext context) {
    if (category == null) {
      return AppLocalizations.of(context)!.category_selection_required;
    }
    return null;
  }
}