import 'package:flutter/material.dart';
import 'package:trackerapp/bloc/data/data_bloc.dart';
import 'package:trackerapp/components/back_button.dart';
import 'package:trackerapp/components/data_list.dart';

class HomePageComp extends StatelessWidget {
  final BuildContext builderContext;
  final MaterialColor theme;
  final String username;
  final dynamic state;
  final DataBloc dataBloc;
  final Widget buttonNewSomething;
  final bool isLoading;

  const HomePageComp({
    Key? key,
    required this.builderContext,
    required this.theme,
    required this.username,
    required this.state,
    required this.dataBloc,
    required this.buttonNewSomething,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state is CategoriesLoaded) const SizedBox(width: 10),
                if (state is SubcategoriesLoaded)
                  CustomBackButton(
                      onTap: () => dataBloc.add(LoadCategories()), state: state, dataBloc: dataBloc)
                else if (state is EntriesLoaded)
                  CustomBackButton(
                      onTap: () => dataBloc
                          .add(LoadSubcategories(categoryId: state.categoryId, category: state.category)),
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
                      child: Text('No categories yet...'),
                    ))
              else
                DataList(builderContext: builderContext, state: state, dataBloc: dataBloc),
            if (state is SubcategoriesLoaded)
              if (state.subcategories.isEmpty)
                const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('No subcategories yet...'),
                    ))
              else
                DataList(builderContext: builderContext, state: state, dataBloc: dataBloc),
            if (state is EntriesLoaded)
              if (state.entries.isEmpty)
                const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('No entries yet...'),
                    ))
              else
                DataList(builderContext: builderContext, state: state, dataBloc: dataBloc),
          ],
        ),
        if (isLoading) const Center(child: CircularProgressIndicator())
      ],
    );
  }
}
