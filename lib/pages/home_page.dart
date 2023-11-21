import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/app_colors.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/components/home_page_comp.dart';

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

  void logout(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(Logout());
  }

  Widget addNewCategory() {
    return Container(
      width: 150,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(37, 42, 48, 1),
          borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.add, color: Color.fromRGBO(186, 186, 186, 1), size: 24),
          Text('New Category',
              style: TextStyle(
                  color: Color.fromRGBO(186, 186, 186, 1), fontSize: 16)),
        ],
      ),
    );
  }

  Widget addNewSubCategory() {
    return Container(
      width: 175,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(37, 42, 48, 1),
          borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.add, color: Color.fromRGBO(186, 186, 186, 1), size: 24),
          Text('New SubCategory',
              style: TextStyle(
                  color: Color.fromRGBO(186, 186, 186, 1), fontSize: 16)),
        ],
      ),
    );
  }

  Widget addNewEntry() {
    return Container(
      width: 150,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.add, color: Colors.transparent, size: 24),
          Text('',
              style: TextStyle(
                  color: Color.fromRGBO(186, 186, 186, 1), fontSize: 16)),
        ],
      ),
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
          Timer(const Duration(seconds: 30), () {
            BlocProvider.of<DataBloc>(listennerContext).add(LoadCategories());
          });
        } else if (state is DataOperationSuccess) {
          ScaffoldMessenger.of(listennerContext)
              .showSnackBar(SnackBar(content: Text(state.message)));
          dataBloc.add(LoadCategories());
        }
      },
      builder: (builderContext, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          return HomePageComp(
            builderContext: builderContext,
            theme: primary,
            username: widget.username,
            state: state,
            dataBloc: dataBloc,
            buttonNewSomething: addNewCategory(),
          );
        } else if (state is SubcategoriesLoaded) {
          return HomePageComp(
            builderContext: builderContext,
            theme: primary,
            username: widget.username,
            state: state,
            dataBloc: dataBloc,
            buttonNewSomething: addNewSubCategory(),
          );
        } else if (state is EntriesLoaded) {
          return HomePageComp(
            builderContext: builderContext,
            theme: primary,
            username: widget.username,
            state: state,
            dataBloc: dataBloc,
            buttonNewSomething: addNewEntry(),
          );
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }
}
