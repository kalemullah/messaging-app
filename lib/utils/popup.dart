import 'package:fluttertoast/fluttertoast.dart';

class ToastPopUp {
  void toast(message, bgcolor, textcolor) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: bgcolor,
        textColor: textcolor,
        fontSize: 16.0);
  }
}
