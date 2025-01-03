import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helloworld/models/message.dart';

class ChatServices {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("User").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go throught each user
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String reciverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: reciverID,
        message: message,
        timestamp: timestamp);
    //construct chat room id for the usersers
    List<String> ids = [currentUserID, reciverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
