import 'package:flutter/material.dart';
import 'package:trackerapp/bloc/data_bloc.dart';

import 'package:trackerapp/components/entry_container.dart';

class DataList extends StatelessWidget {
  final BuildContext builderContext;
  final dynamic state;
  final dynamic dataBloc;

  const DataList(
      {Key? key,
      required this.builderContext,
      required this.state,
      required this.dataBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = 0;
    if (state is CategoriesLoaded) {
      length = state.categories.length;
    } else if (state is SubCategoriesLoaded) {
      length = state.subcategories.length;
    } else if (state is EntriesLoaded) {
      length = state.entries.length;
    }
    return SizedBox(
      height: MediaQuery.of(builderContext).size.height - 310,
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (BuildContext builderContext, int index) {
          if (state is CategoriesLoaded) {
            return EntryContainer(
                onTap: () => dataBloc.add(GoToSubCategoryPage(
                    data: state.data, category: state.categories[index])),
                word: state.categories[index],
                index: index);
          } else if (state is SubCategoriesLoaded) {
            return EntryContainer(
                onTap: () => dataBloc.add(GoToEntryPage(
                    data: state.data,
                    category: state.category,
                    subcategory: state.subcategories[index])),
                word: state.subcategories[index],
                index: index);
          } else if (state is EntriesLoaded) {
            return EntryContainer(
                onTap: () {}, word: state.entries[index].value, index: index);
          }
        },
      ),
    );
  }
}
