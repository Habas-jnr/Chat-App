import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: EdgeInsets.all(9),
        child: Row(
          children: [
            SizedBox(width: 10),
            //Tcon
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(Icons.person),
            ),
            SizedBox(width: 20),
            //Name
            Text(text),
          ],
        ),
      ),
    );
  }
}
