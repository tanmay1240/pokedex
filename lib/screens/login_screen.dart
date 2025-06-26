import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'pokedex_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/pokeball.json', height: 250),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Your Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PokedexScreen(username: nameController.text.trim()),
                ),
              );
            },
            child: Text("Enter Poképedia"),
          ),
        ],
      ),
    );
  }
}
