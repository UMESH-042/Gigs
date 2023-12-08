
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAboutMe(String userId, String aboutMe) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).set({
        'aboutMe': aboutMe,
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding About Me: $e');
    }
  }

  Future<void> updateAboutMe(String userId, String aboutMe) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'aboutMe': aboutMe,
      });
    } catch (e) {
      // Handle error
      print('Error updating About Me: $e');
    }
  }


  Future<void> addWorkExperience(String userId, Map<String, dynamic> workExperience) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'workExperience': FieldValue.arrayUnion([workExperience]),
      });
    } catch (e) {
      // Handle error
      print('Error adding Work Experience: $e');
    }
  }

  Future<void> updateWorkExperience(String userId, int index, Map<String, dynamic> updatedWorkExperience) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'workExperience.$index': updatedWorkExperience,
      });
    } catch (e) {
      // Handle error
      print('Error updating Work Experience: $e');
    }
  }
Future<void> addEducation(String userId, Map<String, dynamic> education) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).set({
        'education': FieldValue.arrayUnion([education]),
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding Education: $e');
    }
  }

  Future<void> updateEducation(String userId, int index, Map<String, dynamic> updatedEducation) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'education.$index': updatedEducation,
      });
    } catch (e) {
      // Handle error
      print('Error updating Education: $e');
    }
  }

  Future<void> addSkills(String userId, List<String> skills) async {
  try {
    await _firestore.collection('usersProfile').doc(userId).update({
      'skills': FieldValue.arrayUnion(skills),
    });
  } catch (e) {
    // Handle error
    print('Error adding Skills: $e');
  }
}



 Future<void> addLanguages(String userId, List<String> languages) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'languages': FieldValue.arrayUnion(languages),
      });
    } catch (e) {
      // Handle error
      print('Error adding Languages: $e');
    }
  }

  Future<void> updateLanguages(String userId, List<String> languages) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'languages': languages,
      });
    } catch (e) {
      // Handle error
      print('Error updating Languages: $e');
    }
  }


  Future<void> addAppreciation(String userId, Map<String, dynamic> appreciation) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).set({
        'appreciation': FieldValue.arrayUnion([appreciation]),
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding Education: $e');
    }
  }

  Future<void> updateAppreciation(String userId, int index, Map<String, dynamic> updatedAppreciation) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).update({
        'appreciation.$index': updatedAppreciation,
      });
    } catch (e) {
      // Handle error
      print('Error updating Appreciation: $e');
    }
  }


  Future<void> addResumeData(String userId, Map<String, dynamic> ResumeData) async {
    try {
      await _firestore.collection('usersProfile').doc(userId).set({
        'Resume': FieldValue.arrayUnion([ResumeData]),
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding Education: $e');
    }
  }

  

  Future<void> deleteResumeData(String userId, int indexToDelete) async {
  try {
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await _firestore.collection('usersProfile').doc(userId).get();

      if (!userSnapshot.exists) {
        // Handle case where user document does not exist
        print('User document does not exist.');
        return;
      }

      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        List<dynamic> resumeArray = userData['Resume'] ?? [];

        if (indexToDelete >= 0 && indexToDelete < resumeArray.length) {
          resumeArray.removeAt(indexToDelete);

          await transaction.update(
            _firestore.collection('usersProfile').doc(userId),
            {'Resume': resumeArray},
          );
        } else {
          // Handle case where the index is out of bounds
          print('Index out of bounds.');
        }
      } else {
        // Handle case where userData is null
        print('User data is null.');
      }
    });
  } catch (e) {
    // Handle error
    print('Error deleting Resume at index $indexToDelete: $e');
  }
}




}



