import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'package:trackerapp/app_colors.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/components/custom_nav_bar.dart';
import 'package:trackerapp/components/entry_container.dart';

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
    return BlocConsumer<DataBloc, DataState>(
      listener: (dataContext, state) {
        if (state.firstLoad == false) {
          BlocProvider.of<DataBloc>(dataContext).add(LoadUserEvent());
          BlocProvider.of<DataBloc>(dataContext).add(GetAllDataEvent());
          BlocProvider.of<DataBloc>(dataContext).add(GetCategoriesEvent());
          state.firstLoad = true;
        }
        else if (state.dataLoaded == false) {
          BlocProvider.of<DataBloc>(dataContext).add(GetAllDataEvent());
        } else if (state.currentPage == 'categories') {
          BlocProvider.of<DataBloc>(dataContext).add(GetCategoriesEvent());
        } else if (state.currentPage == 'subcategories') {
          BlocProvider.of<DataBloc>(dataContext)
              .add(GetSubCategoriesEvent(category: state.selectedCategory!));
        } else if (state.currentPage == 'entries') {
          BlocProvider.of<DataBloc>(dataContext).add(GetEntriesByCategoryEvent(
              category: state.selectedCategory!,
              subcategory: state.selectedSubcategory!));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
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
                                padding:
                                    const EdgeInsets.only(left: 20, top: 35),
                                color: const Color.fromRGBO(37, 42, 48, 1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome, ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(username,
                                        style: TextStyle(
                                            color: primary[10],
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold)),
                                    const Text('!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                                color: const Color.fromRGBO(
                                                    37, 42, 48, 1),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    bottom: 6),
                                                width: 70,
                                                child: const Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          height: 16,
                                                          child: Icon(
                                                              Icons
                                                                  .list_rounded,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      186,
                                                                      186,
                                                                      186,
                                                                      1),
                                                              size: 24)),
                                                      SizedBox(width: 4),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4.0),
                                                        child: Text('All',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        186,
                                                                        186,
                                                                        186,
                                                                        1),
                                                                fontSize: 16)),
                                                      )
                                                    ]))),
                                        Row(children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                color: const Color.fromRGBO(
                                                    37, 42, 48, 1),
                                              )),
                                          const SizedBox(width: 8),
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                color: const Color.fromRGBO(
                                                    37, 42, 48, 1),
                                              )),
                                          const SizedBox(width: 8),
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                color: const Color.fromRGBO(
                                                    37, 42, 48, 1),
                                              ))
                                        ]),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              37, 42, 48, 1),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: Color.fromRGBO(
                                                  186, 186, 186, 1),
                                              size: 24),
                                          Text('New Category',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      186, 186, 186, 1),
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              300,
                                      child: ListView.builder(
                                        itemCount: 8,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return EntryContainer(
                                              word: state.categoryData![index]
                                                  .category,
                                              index: index);
                                        },
                                      ),
                                    ),
                                  ])),
                        ])),
              ),
              CustomNavBar(
                buttonColor: primary[10]!,
                onPressed: () {},
              )
            ],
          ),
        );
      },
    );
  }
}
