import 'package:intl/intl.dart';

class MyCurrentDate{

 static String myDate(){
    var dateTime = DateTime.now();
    var date = DateFormat('dd/MM/yyyy').format(dateTime);
    var getDate = date.toString();

    return getDate;
  }
}