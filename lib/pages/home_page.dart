import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/app_colors.dart';
import 'package:trackerapp/bloc/login_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  String selectedPalette = "";
  // final List<String> paletteNames = [
  //   "primary",
  //   "paletteblue",
  //   "palettepurple",
  //   "palettegreen",
  //   "paletterainbow",
  //   "palettepink",
  //   "palettered",
  //   "paletteredtoyellow",
  // ];

  void logout(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(LogoutPressed());
  }

  @override
  void initState() {
    super.initState();
    username = BlocProvider.of<LoginBloc>(context).state.username!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 30,
                      offset: const Offset(2, 0),
                    ),
                  ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32)),
                    child: Container(
                      height: 110,
                      padding: const EdgeInsets.only(left: 20, top: 35),
                      color: const Color.fromRGBO(37, 42, 48, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(username,
                              style: TextStyle(
                                  color: primary[10],
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(children: <Widget>[
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: const Color.fromRGBO(37, 42, 48, 1),
                              padding: const EdgeInsets.all(8),
                              height: 30,
                              width: 70,
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 16,
                                      width: 24,
                                      child: Icon(Icons.list,
                                          color:
                                              Color.fromRGBO(186, 186, 186, 1),
                                          size: 24)),
                                  SizedBox(width: 4),
                                  Text('All',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(186, 186, 186, 1),
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
              ])))),
    );
  }
}
