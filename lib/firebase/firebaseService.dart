
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAboutMe(String userId, String aboutMe) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'aboutMe': aboutMe,
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding About Me: $e');
    }
  }

  Future<void> updateAboutMe(String userId, String aboutMe) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'aboutMe': aboutMe,
      });
    } catch (e) {
      // Handle error
      print('Error updating About Me: $e');
    }
  }


  Future<void> addWorkExperience(String userId, Map<String, dynamic> workExperience) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'workExperience': FieldValue.arrayUnion([workExperience]),
      });
    } catch (e) {
      // Handle error
      print('Error adding Work Experience: $e');
    }
  }

  Future<void> updateWorkExperience(String userId, int index, Map<String, dynamic> updatedWorkExperience) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'workExperience.$index': updatedWorkExperience,
      });
    } catch (e) {
      // Handle error
      print('Error updating Work Experience: $e');
    }
  }
Future<void> addEducation(String userId, Map<String, dynamic> education) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'education': FieldValue.arrayUnion([education]),
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding Education: $e');
    }
  }

  Future<void> updateEducation(String userId, int index, Map<String, dynamic> updatedEducation) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'education.$index': updatedEducation,
      });
    } catch (e) {
      // Handle error
      print('Error updating Education: $e');
    }
  }

  Future<void> addSkills(String userId, List<String> skills) async {
  try {
    await _firestore.collection('users').doc(userId).update({
      'skills': FieldValue.arrayUnion(skills),
    });
  } catch (e) {
    // Handle error
    print('Error adding Skills: $e');
  }
}



 Future<void> addLanguages(String userId, List<String> languages) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'languages': FieldValue.arrayUnion(languages),
      });
    } catch (e) {
      // Handle error
      print('Error adding Languages: $e');
    }
  }

  Future<void> updateLanguages(String userId, List<String> languages) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'languages': languages,
      });
    } catch (e) {
      // Handle error
      print('Error updating Languages: $e');
    }
  }


  Future<void> addAppreciation(String userId, Map<String, dynamic> appreciation) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'appreciation': FieldValue.arrayUnion([appreciation]),
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding Education: $e');
    }
  }

  Future<void> updateAppreciation(String userId, int index, Map<String, dynamic> updatedAppreciation) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'appreciation.$index': updatedAppreciation,
      });
    } catch (e) {
      // Handle error
      print('Error updating Appreciation: $e');
    }
  }



}



