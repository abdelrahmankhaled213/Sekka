import 'package:intl/intl.dart';

abstract class DateTimeHelper {
  
static String formatTimestamp(String supabaseDate) {
  if (supabaseDate.isEmpty) return "";
  
  try {
 
    DateTime utcTime = DateTime.parse(supabaseDate);
 
    DateTime localTime = utcTime.toLocal();
    
 
    return DateFormat.jm().format(localTime);
  } catch (e) {
    return ""; 
  }
}

}