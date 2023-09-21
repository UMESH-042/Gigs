
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

}
