// import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/Components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/auth/chat/chat_services.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthServices _auth = AuthServices();
  final ChatServices _chatService = ChatServices();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: myAppBar(isDarkMode, context),

      body: _buildUserList(),
    );
  }

  AppBar myAppBar(bool isDarkMode, BuildContext context) {
    return AppBar(
      toolbarHeight: 140,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey.shade800,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 100),
        child: Text(
          "FAmiLia 💕",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          icon:
              isDarkMode
                  ? Icon(Icons.light_mode, color: Colors.white, size: 30)
                  : Icon(Icons.dark_mode, size: 30),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SettingsPage()),
            );
          },
          icon:
              isDarkMode
                  ? Icon(Icons.settings, color: Colors.white, size: 30)
                  : Icon(Icons.settings, size: 30),
        ),
      ],
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
          return Center(child: Text("Loading"));
        }

        //return listview

        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            children:
                snapshot.data!
                    .map<Widget>(
                      (userData) => _buildUserListItem(userData, context),
                    )
                    .toList(),
          ),
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
