import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/components/back_button.dart';
import 'package:trackerapp/components/custom_nav_bar.dart';
import 'package:trackerapp/components/data_list.dart';
import 'package:intl/intl.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/models/entry.dart';

class HomePageComp extends StatelessWidget {
  final BuildContext builderContext;
  final MaterialColor theme;
  final String username;
  final dynamic state;
  final DataBloc dataBloc;
  final Widget buttonNewSomething;

  const HomePageComp({
    Key? key,
    required this.builderContext,
    required this.theme,
    required this.username,
    required this.state,
    required this.dataBloc,
    required this.buttonNewSomething,
  }) : super(key: key);

  void addEntry(BuildContext oldContext, List<Entry> data, String? category,
      String? subcategory) {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController subcategoryController = TextEditingController();
    final TextEditingController valueController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    if (category != null) {
      categoryController.text = category;
    }
    if (subcategory != null) {
      subcategoryController.text = subcategory;
    }

    showDialog(
      context: oldContext,
      builder: ((context) => AlertDialog(
            title: const Text('Add Entry'),
            content: SizedBox(
              height: 250,
              child: Column(
                children: [
                  MyTextField(
                    controller: categoryController,
                    hintText: 'Category',
                    obscureText: false,
                  ),
                  const SizedBox(height: 8),
                  MyTextField(
                    controller: subcategoryController,
                    hintText: 'SubCategory',
                    obscureText: false,
                  ),
                  const SizedBox(height: 8),
                  MyTextField(
                    controller: valueController,
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
                      category: categoryController.text,
                      subcategory: subcategoryController.text,
                      value: valueController.text,
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
    print('State is $state');
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
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(username,
                                style: TextStyle(
                                    color: theme[10],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                        color:
                                            const Color.fromRGBO(37, 42, 48, 1),
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 6),
                                        width: 70,
                                        child: const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 16,
                                                  child: Icon(
                                                      Icons.list_rounded,
                                                      color: Color.fromRGBO(
                                                          186, 186, 186, 1),
                                                      size: 24)),
                                              SizedBox(width: 4),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 4.0),
                                                child: Text('All',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            186, 186, 186, 1),
                                                        fontSize: 16)),
                                              )
                                            ]))),
                                Row(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color:
                                            const Color.fromRGBO(37, 42, 48, 1),
                                      )),
                                  const SizedBox(width: 8),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color:
                                            const Color.fromRGBO(37, 42, 48, 1),
                                      )),
                                  const SizedBox(width: 8),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color:
                                            const Color.fromRGBO(37, 42, 48, 1),
                                      ))
                                ]),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (state is CategoriesLoaded)
                                  const SizedBox(width: 10),
                                if (state is SubCategoriesLoaded)
                                  CustomBackButton(
                                      onTap: () => dataBloc.add(
                                            GoToCategoriesPage(
                                              data: state.data,
                                            ),
                                          ),
                                      state: state,
                                      dataBloc: dataBloc)
                                else if (state is EntriesLoaded)
                                  CustomBackButton(
                                      onTap: () => dataBloc.add(
                                            GoToSubCategoryPage(
                                              data: state.data,
                                              category: state.category,
                                            ),
                                          ),
                                      state: state,
                                      dataBloc: dataBloc),
                                buttonNewSomething,
                              ],
                            ),
                            if (state is CategoriesLoaded)
                              if (state.categories.isEmpty)
                                const SizedBox(
                                    height: 200,
                                    child: Center(
                                        child: Text('No categories yet.')))
                              else
                                DataList(
                                    builderContext: builderContext,
                                    state: state,
                                    dataBloc: dataBloc),
                            if (state is SubCategoriesLoaded)
                              if (state.subcategories.isEmpty)
                                const SizedBox(
                                    height: 200,
                                    child: Center(
                                        child: Text('No subcategories yet.')))
                              else
                                DataList(
                                    builderContext: builderContext,
                                    state: state,
                                    dataBloc: dataBloc),
                            if (state is EntriesLoaded)
                              if (state.entries.isEmpty)
                                const SizedBox(
                                    height: 200,
                                    child:
                                        Center(child: Text('No entries yet.')))
                              else
                                DataList(
                                    builderContext: builderContext,
                                    state: state,
                                    dataBloc: dataBloc),
                          ])),
                ])),
          ),
          CustomNavBar(
            context: builderContext,
            buttonColor: theme[10]!,
            onPressed: () {
              if (state is CategoriesLoaded) {
                addEntry(builderContext, state.data, null, null);
              } else if (state is SubCategoriesLoaded) {
                addEntry(builderContext, state.data, state.category, null);
              } else if (state is EntriesLoaded) {
                addEntry(builderContext, state.data, state.category,
                    state.subcategory);
              }
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
