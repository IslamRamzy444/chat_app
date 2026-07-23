class AppValidators {
  AppValidators._();
  static String? validateEmail(String? val){
    RegExp emailRegex=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if(val==null || val.trim().isEmpty){
      return "This Field is requied";
    }else if(emailRegex.hasMatch(val.trim())==false){
      return "Enter a valid email";
    }else{
      return null;
    }
  }
  static String? validatePassword(String? val){
    RegExp passwordRegex=RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])');
    if(val==null || val.trim().isEmpty){
      return "This Field is required";
    }else if(val.length<8 || passwordRegex.hasMatch(val.trim())==false){
      return "Enter a valid password";
    }else{
      return null;
    }
  }
  static String? validateConfirmPassword(String? val,String? password){
    if(val==null || val.trim().isEmpty){
      return "This Field is required";
    }else if(val.trim()!=password?.trim()){
      return "Passwords not matching";
    }else{
      return null;
    }
  }
  static String? validateUserName(String? val){
    RegExp userNameRegex=RegExp(r'^[a-zA-Z0-9,.-]+$');
    if(val==null || val.trim().isEmpty){
      return "This Field is required";
    }else if(!userNameRegex.hasMatch(val.trim())){
      return "Enter a valid user name";
    }else{
      return null;
    }
  }
}