import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/colors.dart' as colors;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  String selectedPalette = ""; 
  final List<String> paletteNames = [
    "primary",
    "paletteblue",
    "palettepurple",
    "palettegreen",
    "paletterainbow",
    "palettepink",
    "palettered",
    "paletteredtoyellow",
  ];

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  void getUsername() async {

    String name = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data()!['username']);

    setState(() {
      username = name;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    // loadSelectedPalette();
  }

  // void saveSelectedPalette(String paletteName) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('selectedPalette', paletteName);
  //   setState(() {
  //     selectedPalette = paletteName;
  //   });
  // }

  // void loadSelectedPalette() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     selectedPalette = prefs.getString('selectedPalette') ?? "";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text(
              'Welcome, $username',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => logout(context),
              child: const Text('Logout'),
            ),
            // ListView.builder(
            //   itemCount: paletteNames.length,
            //   itemBuilder: (context, index) {
            //     final paletteName = paletteNames[index];
            //     final isSelected = paletteName == selectedPalette;
            //     return ListTile(
            //       title: Text(paletteName),
            //       onTap: () {
            //         saveSelectedPalette(paletteName);
            //       },
            //       tileColor: isSelected ? Colors.grey : null,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
