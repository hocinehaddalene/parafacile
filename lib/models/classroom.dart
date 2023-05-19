import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parafacile/views/classroom_item.dart';

class Classroom {
  String? className;
  String? classDescription;
  String? selectedNiveau;
  String? Selectedspecialite;

  Classroom();

  CollectionReference classReference =
      FirebaseFirestore.instance.collection("Classes");
  CollectionReference studentReference =
      FirebaseFirestore.instance.collection("Students");

  Future<void>? addClass(
      String? className,
      String? classDescription,
      String? selectedNiveau,
      String? Selectedspecialite,
      String? CurrentUserId) async {
    return await classReference.doc(className).set({
      'className': className,
      'description': classDescription,
      'niveau': selectedNiveau,
      'specialite': Selectedspecialite,
      'idProfesseur': CurrentUserId
    });
  }

  Future getClasses(
      String? className,
      String? classDescription,
      String? selectedNiveau,
      String? Selectedspecialite,
      String? CurrentUserId) async {
    late var query = FirebaseFirestore.instance
        .collection('Classes')
        .where('idProfesseur', isEqualTo: CurrentUserId);
    List<ClassroomItem> ClassroomList = [];
    var querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) {
      // Extract the data from the document
      var data = doc.data();
      var ClassroomItemWidget = ClassroomItem(
        title: className,
        classDescription: classDescription,
      );
      ClassroomList.add(ClassroomItemWidget);
    });
  }
}
