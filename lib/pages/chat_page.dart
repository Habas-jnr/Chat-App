import 'package:chat_app/Components/chat_bubble.dart';
import 'package:chat_app/Components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/auth/chat/chat_services.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  const ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthServices _authservice = AuthServices();

  final ChatServices _chatService = ChatServices();

  final TextEditingController _messageController = TextEditingController();

  //for textfied focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listner to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause a delay so that keyboard can show up
        //calculate the remain space
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //Scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    //if Textfield is not empty
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatService.sendMessage(
        widget.recieverID,
        _messageController.text,
      );
    }

    //clear controller
    _messageController.clear();

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.green.shade800 : Colors.grey,
        foregroundColor: isDarkMode ? Colors.grey[1000] : Colors.grey[900],
        elevation: 5,
        title: Text(
          widget.recieverEmail,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          //display all messages
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authservice.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data == null) {
          return Container();
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //check if it's current user

    bool isCurrentUser = data['senderID'] == _authservice.getCurrentUser()!.uid;

    //align to left if current user otherwise align to right
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
    );
  }

  //Message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              focusNode: myFocusNode,
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
            ),
          ),
        ],
      ),
    );
  }
}
