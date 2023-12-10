
import 'package:bbb/pages/components/my_text_field.dart';
import 'package:bbb/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail; 
  final String receiverUserID; 
  const ChatPage(
    {super.key, 
    required this.receiveruserEmail, 
    required this.receiverUserID
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

final TextEditingController _messageController = TextEditingController();
final ChatService _chatService = ChatService();
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

void sendMessage() async{
 if(_messageController.text.isNotEmpty){
   await _chatService.sendMessage(
     widget.receiverUserID,
     _messageController.text,
   );
   _messageController.clear();
 }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveruserEmail),),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          _buildMessageInput(),
        ],
      ),
    );
  }


Widget _buildMessageList(){
  return StreamBuilder(
    stream: _chatService.getMessages
    (widget.receiverUserID, _firebaseAuth.currentUser!.uid)
  , builder:(context, snapshot){
    if(snapshot.hasError){
      return Text('Error ${snapshot.error}');
    }
    if(snapshot.connectionState == ConnectionState.waiting){
      return const Text('Loading...');
    }
    return ListView(
      children: snapshot.data!.docs
      .map((doc) => _buildMessageItem(doc))
      .toList(),
    );
  }
  );
}

Widget _buildMessageInput() {
  return Row(
    children: [
      Expanded(child: 
      MyTextField(
        controller: _messageController,
        hintText: "Enter a message",
        obscureText: false,
        ),
        ),
        IconButton(
          onPressed:  sendMessage,
          icon: const Icon(Icons.arrow_upward,
          size: 30,),
          
        ),
  ]
  ,);
}

Widget _buildMessageItem(DocumentSnapshot doc){
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  var aligment = (data['senderID'] == _firebaseAuth.currentUser!.uid) 
  ? Alignment.centerRight 
  : Alignment.centerLeft;

return Container(
  alignment: aligment,
  child: Column
    (children: [ 
    Text(data['senderEmail']),
    Text(data['message']),
  ]
  ),
);

}




}