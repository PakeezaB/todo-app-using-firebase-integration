// ignore: file_names
// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static Future<void> saveUser(String name, String email, String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name});
  }

  static Future<void> addTask(String uid, String task) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add({'task': task, 'timestamp': FieldValue.serverTimestamp()});
  }

  static Stream<QuerySnapshot> getUserTasks(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('timestamp')
        .snapshots();
  }

  static Future<void> deleteTask(String uid, String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  static Future<void> updateTask(
      String uid, String taskId, String updatedTask) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'task': updatedTask});
  }
}
