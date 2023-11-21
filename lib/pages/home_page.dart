import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/app_colors.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/components/custom_nav_bar.dart';
import 'package:trackerapp/components/home_page_comp.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String selectedPalette = "";
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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DataBloc>(context).add(LoadCategories());
  }

  void addEntry(BuildContext oldContext) {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController subcategoryController = TextEditingController();
    final TextEditingController valueController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    // if (category != null) {
    //   categoryController.text = category;
    // }
    // if (subcategory != null) {
    //   subcategoryController.text = subcategory;
    // }

    showDialog(
      context: oldContext,
      builder: ((context) => AlertDialog(
              backgroundColor: const Color.fromRGBO(37, 42, 48, 1),
              title: const Text('Add Entry', style: TextStyle(color: Colors.white)),
              content: SizedBox(
                  height: 250,
                  child: Column(children: [
                    MyTextField(controller: categoryController, hintText: 'Category', obscureText: false),
                    const SizedBox(height: 8),
                    MyTextField(
                        controller: subcategoryController, hintText: 'SubCategory', obscureText: false),
                    const SizedBox(height: 8),
                    MyTextField(controller: valueController, hintText: 'Value', obscureText: false),
                    const SizedBox(height: 8),
                    DateTimeField(
                        style: const TextStyle(color: Colors.white),
                        format: DateFormat('dd/MM/yyyy HH:mm'),
                        decoration: const InputDecoration(
                            labelText: 'Date/Time',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            )),
                        initialValue: selectedDate,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: currentValue ?? selectedDate,
                          );
                          if (date != null) {
                            // ignore: use_build_context_synchronously
                            final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? selectedDate),
                                builder: (context, child) => child!);
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                        onChanged: (dateTime) {
                          if (dateTime != null) {
                            selectedDate = dateTime;
                          }
                        })
                  ])),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: primary[10])),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primary[10]),
                    textStyle:
                        MaterialStateProperty.all(const TextStyle(color: Color.fromARGB(186, 186, 186, 1))),
                  ),
                  onPressed: () {
                    BlocProvider.of<DataBloc>(oldContext).add(
                      CreateEntry(
                        id: Timestamp.now().toString(),
                        category: categoryController.text,
                        subcategory: subcategoryController.text,
                        value: valueController.text,
                        date: selectedDate,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                )
              ])),
    );
  }

  void logout(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(Logout());
  }

  Widget addNewSomething(String text, Function() onTap, dynamic state) {
    return Container(
      width: state is SubcategoriesLoaded ? 175 : 150,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: state is EntriesLoaded ? Colors.transparent : const Color.fromRGBO(37, 42, 48, 1),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          state is! EntriesLoaded
              ? const Icon(Icons.add, color: Color.fromRGBO(186, 186, 186, 1), size: 24)
              : const SizedBox(),
          Text(text, style: const TextStyle(color: Color.fromRGBO(186, 186, 186, 1), fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DataBloc dataBloc = BlocProvider.of<DataBloc>(context);

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
                                bottomRight: Radius.circular(32),
                              ),
                              child: Container(
                                  height: 110,
                                  padding: const EdgeInsets.only(left: 20, top: 35),
                                  color: const Color.fromRGBO(37, 42, 48, 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Welcome, ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(widget.username,
                                          style: TextStyle(
                                            color: primary[10],
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      const Text('!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ],
                                  )))),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                          color: const Color.fromRGBO(37, 42, 48, 1),
                                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                                          width: 70,
                                          child: const Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 16,
                                                  child: Icon(
                                                    Icons.list_rounded,
                                                    color: Color.fromRGBO(186, 186, 186, 1),
                                                    size: 24,
                                                  )),
                                              SizedBox(width: 4),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    'All',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(186, 186, 186, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ))
                                            ],
                                          ))),
                                  Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            color: const Color.fromRGBO(37, 42, 48, 1),
                                          )),
                                      const SizedBox(width: 8),
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            color: const Color.fromRGBO(37, 42, 48, 1),
                                          )),
                                      const SizedBox(width: 8),
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            color: const Color.fromRGBO(37, 42, 48, 1),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              BlocConsumer<DataBloc, DataState>(
                                listener: (listennerContext, state) {
                                  if (state is DataError) {
                                    ScaffoldMessenger.of(listennerContext)
                                        .showSnackBar(SnackBar(content: Text(state.message)));
                                    Timer(const Duration(seconds: 30), () {
                                      BlocProvider.of<DataBloc>(listennerContext).add(LoadCategories());
                                    });
                                  } else if (state is DataOperationSuccess) {
                                    ScaffoldMessenger.of(listennerContext)
                                        .showSnackBar(SnackBar(content: Text(state.message)));
                                  }
                                },
                                builder: (builderContext, state) {
                                  print(state);
                                  if (state is CategoriesLoaded) {
                                    return HomePageComp(
                                      builderContext: builderContext,
                                      theme: primary,
                                      username: widget.username,
                                      state: state,
                                      dataBloc: dataBloc,
                                      buttonNewSomething: addNewSomething('New Category', () {}, state),
                                      isLoading: state is DataLoading,
                                    );
                                  } else if (state is SubcategoriesLoaded) {
                                    return HomePageComp(
                                      builderContext: builderContext,
                                      theme: primary,
                                      username: widget.username,
                                      state: state,
                                      dataBloc: dataBloc,
                                      buttonNewSomething: addNewSomething('New Subcategory', () {}, state),
                                      isLoading: state is DataLoading,
                                    );
                                  } else if (state is EntriesLoaded) {
                                    return HomePageComp(
                                      builderContext: builderContext,
                                      theme: primary,
                                      username: widget.username,
                                      state: state,
                                      dataBloc: dataBloc,
                                      buttonNewSomething: addNewSomething('', () {}, state),
                                      isLoading: state is DataLoading,
                                    );
                                  } else if (state is DataLoading) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else {
                                    return const Center(child: Text('Unknown state'));
                                  }
                                  
                                },
                              ),
                            ],
                          )),
                    ],
                  ))),
          CustomNavBar(
            context: context,
            buttonColor: primary[10]!,
            onPressed: () {
              addEntry(context);
            },
            homeFunction: () {},
            historyFunction: () {},
            chartFunction: () {},
            profileFunction: () {},
          )
        ],
      ),
    );
  }
}
