import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
    static String userLoggedInKey ='LOGGEDINKEY';
    static String userNameKey ='USERNAMEKEY';
    static String userEmailKey ='USEREMAILKEY';

    static Future<bool> setUserLoggedInStatus(bool isLoggedIn) async{
      SharedPreferences sf = await SharedPreferences.getInstance();
      return await sf.setBool(userLoggedInKey, isLoggedIn);
    }
    static Future<bool> setUserNameSF(String name) async{
      SharedPreferences sf = await SharedPreferences.getInstance();
      return await sf.setString(userNameKey, name);
    }
    static Future<bool> setUserEmailSF(String email) async{
      SharedPreferences sf = await SharedPreferences.getInstance();
      return await sf.setString(userEmailKey, email);
    }
   

    static Future<bool?> getUserLoggedInStatus() async{
      SharedPreferences sf = await SharedPreferences.getInstance();
      return sf.getBool(userLoggedInKey);
    }
    static Future<String?> getUserName() async{
      SharedPreferences sf = await SharedPreferences.getInstance();
      return sf.getString(userNameKey);
    }
    static Future<String?> getUserEmail() async{
      SharedPreferences sf = await SharedPreferences.getInstance();
      return sf.getString(userEmailKey);
    }

}