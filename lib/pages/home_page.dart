import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:trackerapp/app_colors.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/components/custom_nav_bar.dart';
import 'package:trackerapp/components/entry_container.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:intl/intl.dart';
import 'package:trackerapp/models/entry.dart';

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
    BlocProvider.of<DataBloc>(context).add(LoadData());
    username = BlocProvider.of<LoginBloc>(context).state.username!;
  }

  void addEntry(BuildContext oldContext, List<Entry> data) {
    final TextEditingController category = TextEditingController();
    final TextEditingController subcategory = TextEditingController();
    final TextEditingController value = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: oldContext,
      builder: ((context) => AlertDialog(
            title: const Text('Add Entry'),
            content: SizedBox(
              height: 250,
              child: Column(
                children: [
                  MyTextField(
                    controller: category,
                    hintText: 'Category',
                    obscureText: false,
                  ),
                  const SizedBox(height: 8),
                  MyTextField(
                    controller: subcategory,
                    hintText: 'SubCategory',
                    obscureText: false,
                  ),
                  const SizedBox(height: 8),
                  MyTextField(
                    controller: value,
                    hintText: 'Value',
                    obscureText: false,
                  ),
                  const SizedBox(height: 8),
                  DateTimeField(
                    format: DateFormat('dd/MM/yyyy HH:mm'),
                    decoration: const InputDecoration(
                      labelText: 'Date/Time',
                    ),
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
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? selectedDate),
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
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  BlocProvider.of<DataBloc>(oldContext).add(
                    AddEntry(
                      id: Timestamp.now().toString(),
                      category: category.text,
                      subcategory: subcategory.text,
                      value: value.text,
                      date: selectedDate,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DataBloc dataBloc = BlocProvider.of<DataBloc>(context);

    return BlocConsumer<DataBloc, DataState>(
      listener: (listennerContext, state) {
        if (state is DataError) {
          ScaffoldMessenger.of(listennerContext)
              .showSnackBar(SnackBar(content: Text(state.message)));
          print(state.message);
          Timer(const Duration(seconds: 30), () {
            BlocProvider.of<DataBloc>(listennerContext).add(LoadData());
          });
        } else if (state is DataOperationSuccess) {
          ScaffoldMessenger.of(listennerContext)
              .showSnackBar(SnackBar(content: Text(state.message)));
          dataBloc.add(LoadData());
        }
      },
      builder: (builderContext, state) {
        print(state);
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          dataBloc.add(GoToCategoriesPage(data: state.data));
        } else if (state is CategoriesLoaded) {
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(builderContext).size.width,
                        minHeight: MediaQuery.of(builderContext).size.height,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                  fontSize:
                                                                      16)),
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
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
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
                                      if (state.categories.isEmpty)
                                        const SizedBox(
                                            height: 200,
                                            child: Center(
                                                child:
                                                    Text('No categories yet.')))
                                      else
                                        SizedBox(
                                          height: MediaQuery.of(builderContext)
                                                  .size
                                                  .height -
                                              375,
                                          child: ListView.builder(
                                            itemCount: state.categories.length,
                                            itemBuilder:
                                                (BuildContext builderContext,
                                                    int index) {
                                              return EntryContainer(
                                                  onTap: () => dataBloc.add(
                                                      GoToSubCategoryPage(
                                                          data: state.data,
                                                          category:
                                                              state.categories[
                                                                  index])),
                                                  word: state.categories[index],
                                                  index: index);
                                            },
                                          ),
                                        ),
                                    ])),
                          ])),
                ),
                CustomNavBar(
                  context: builderContext,
                  buttonColor: primary[10]!,
                  onPressed: () => addEntry(builderContext, state.data),
                )
              ],
            ),
          );
        } else if (state is SubCategoriesLoaded) {
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(builderContext).size.width,
                        minHeight: MediaQuery.of(builderContext).size.height,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                  fontSize:
                                                                      16)),
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
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
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
                                      if (state.subcategories.isEmpty)
                                        const SizedBox(
                                            height: 200,
                                            child: Center(
                                                child: Text(
                                                    'No subcategories yet.')))
                                      else
                                        Column(
                                          children: [
                                            SizedBox(
                                              height:
                                                  MediaQuery.of(builderContext)
                                                          .size
                                                          .height -
                                                      375,
                                              child: ListView.builder(
                                                itemCount:
                                                    state.subcategories.length,
                                                itemBuilder: (BuildContext
                                                        builderContext,
                                                    int index) {
                                                  return EntryContainer(
                                                      onTap: () => dataBloc.add(
                                                              GoToEntryPage(
                                                            data: state.data,
                                                            category:
                                                                state.category,
                                                            subcategory: state
                                                                    .subcategories[
                                                                index],
                                                          )),
                                                      word: state
                                                          .subcategories[index],
                                                      index: index);
                                                },
                                              ),
                                            ),
                                            EntryContainer(
                                                onTap: () => dataBloc.add(
                                                      GoToCategoriesPage(
                                                          data: state.data),
                                                    ),
                                                word: 'Back',
                                                index: 0),
                                          ],
                                        ),
                                    ])),
                          ])),
                ),
                CustomNavBar(
                  context: builderContext,
                  buttonColor: primary[10]!,
                  onPressed: () => addEntry(builderContext, state.data),
                )
              ],
            ),
          );
        } else if (state is EntriesLoaded) {
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(builderContext).size.width,
                        minHeight: MediaQuery.of(builderContext).size.height,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                  fontSize:
                                                                      16)),
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
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
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
                                      if (state.entries.isEmpty)
                                        const SizedBox(
                                            height: 200,
                                            child: Center(
                                                child: Text(
                                                    'No subcategories yet.')))
                                      else
                                        Column(
                                          children: [
                                            SizedBox(
                                              height:
                                                  MediaQuery.of(builderContext)
                                                          .size
                                                          .height -
                                                      375,
                                              child: ListView.builder(
                                                itemCount: state.entries.length,
                                                itemBuilder: (BuildContext
                                                        builderContext,
                                                    int index) {
                                                  return EntryContainer(
                                                      onTap: () {},
                                                      word: state
                                                          .entries[index].value,
                                                      index: index);
                                                },
                                              ),
                                            ),
                                            EntryContainer(
                                                onTap: () => dataBloc.add(
                                                        GoToSubCategoryPage(
                                                      data: state.data,
                                                      category: state.category,
                                                    )),
                                                word: 'Back',
                                                index: 0),
                                          ],
                                        ),
                                    ])),
                          ])),
                ),
                CustomNavBar(
                  context: builderContext,
                  buttonColor: primary[10]!,
                  onPressed: () => addEntry(builderContext, state.data),
                )
              ],
            ),
          );
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }
}
