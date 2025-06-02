// import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/Components/my_drawer.dart';
import 'package:chat_app/Components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/auth/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthServices _auth = AuthServices();
  final ChatServices _chatService = ChatServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade800,
        elevation: 0,
        title: Center(
          child: Text(
            "HOME",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),

      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        //return listview
        return ListView(
          children:
              snapshot.data!
                  .map<Widget>(
                    (userData) => _buildUserListItem(userData, context),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    // display all user except current user
    if (userData["email"] != _auth.getCurrentUser()!.email) {
      return UserTile(
        //user email
        text: userData["email"],

        //onTap
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ChatPage(
                    recieverEmail: userData["email"],
                    recieverID: userData["uid"],
                  ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
