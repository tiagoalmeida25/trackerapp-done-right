import 'package:flutter/material.dart';
import 'package:trackerapp/bloc/data/data_bloc.dart';
import 'package:trackerapp/components/entry_container.dart';

class DataList extends StatelessWidget {
  final BuildContext builderContext;
  final dynamic state;
  final dynamic dataBloc;

  const DataList({Key? key, required this.builderContext, required this.state, required this.dataBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = 0;
    if (state is CategoriesLoaded) {
      length = state.categories.length;
    } else if (state is SubcategoriesLoaded) {
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
              onTap: () => dataBloc.add(LoadSubcategories(
                  categoryId: state.categories[index].categoryId,
                  category: state.categories[index].category)),
              word: state.categories[index].category,
              index: index,
            );
          } else if (state is SubcategoriesLoaded) {
            return EntryContainer(
                onTap: () => dataBloc.add(LoadEntries(
                      category: state.category,
                      categoryId: state.categoryId,
                      subcategory: state.subcategories[index].subcategory,
                      subcategoryId: state.subcategories[index].subcategoryId,
                    )),
                word: state.subcategories[index].subcategory,
                index: index);
          } else if (state is EntriesLoaded) {
            return EntryContainer(
              onTap: () {},
              word: state.entries[index].value,
              index: index,
              date: state.entries[index].date
            );
          }
          return null;
        },
      ),
    );
  }
}
