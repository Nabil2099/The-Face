import 'package:cloud_firestore/cloud_firestore.dart';
// return a formatted data as a string
String formatData(Timestamp timestamp) {
  // Timestamp is the object we retrieve from Firebase
  // so to display it, let's convert it to a String
  DateTime dateTime = timestamp.toDate();

  // get year
  String year = dateTime.year.toString();

  // get month
  String month = dateTime.month.toString();

  // get day
  String day = dateTime.day.toString();

  // final formatted date
  String formattedData = '$day/$month/$year';

  return formattedData;
}
