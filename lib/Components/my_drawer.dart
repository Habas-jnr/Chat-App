import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logOut() {
    final auth = AuthServices();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Header
          Column(
            children: [
              DrawerHeader(child: Image.asset("lib/images/birds.png")),

              //Home
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "Home",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.home),
                  onTap: () => Navigator.pop(context),
                ),
              ),

              //settings
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.settings_applications),
                  onTap: () {
                    //pop drawer first
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 10),
            child: ListTile(
              title: Text(
                "Log Out",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.logout),
              onTap: () => logOut(),
            ),
          ),
        ],
      ),
    );
  }
}
