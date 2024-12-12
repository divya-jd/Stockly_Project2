import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService{

  String uid = '';
  DatabaseService({required this.uid});
  final CollectionReference StockCollection = FirebaseFirestore.instance.collection('My Stocks');

  //for updating user data
  Future updateUserData(String? name, List<String>? Stocks) async {
    return await StockCollection.doc(uid).set({
      'NAME' : name,
      'MY STOCKS': Stocks,
    });
  }


}