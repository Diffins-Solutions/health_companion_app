import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHandler {
  final _fireStore = FirebaseFirestore.instance;

  Future fetchDataWithFilter(String collection, String field, List<dynamic> filter) async {
    var result = [];
    try {
      final querySnapshot = await _fireStore.collection(collection)
          .where(field, whereIn: filter).get();

      for (var doc in querySnapshot.docs) {
        result.add(doc.data());
        print("${doc.id} => ${doc.data()}");
      }
      return result;
    } catch (e) {
      // Handle errors appropriately (e.g., print error message)
      print("Error fetching data: $e");
    }
  }

}
