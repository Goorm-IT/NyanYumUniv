import 'package:shared_preferences/shared_preferences.dart';

class MemoData{
  Future<bool> saveMemo(String text,String classId) async{
    final _props = await SharedPreferences.getInstance();
    return await _props.setString(classId,text);
  }

 Future<Map<String, String>> loadMemo(String classId)async{
     final _props = await SharedPreferences.getInstance();

     return{
       'memoText':_props.getString(classId)??''
     };
  }
}