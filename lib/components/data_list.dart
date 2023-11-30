import 'package:flutter/material.dart';
import 'package:trackerapp/bloc/data/data_bloc.dart';
import 'package:trackerapp/components/entry_container.dart';

class DataList extends StatelessWidget {
  final BuildContext builderContext;
  final dynamic state;
  final dynamic dataBloc;
  final MaterialColor theme;

  const DataList(
      {Key? key,
      required this.theme,
      required this.builderContext,
      required this.state,
      required this.dataBloc})
      : super(key: key);

  void deletePopup(BuildContext context, dynamic dataBloc, dynamic state, MaterialColor theme, int index) {
    String text = '';

    if (state is CategoriesLoaded) {
      text = 'Are you sure you want to delete this category and all subcategories associated?';
    } else if (state is SubcategoriesLoaded) {
      text = 'Are you sure you want to delete this subcategory and all entries associated?';
    } else if (state is EntriesLoaded) {
      text = 'Are you sure you want to delete this entry?';
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: theme[1],
            title: const Text('Delete', style: TextStyle(color: Colors.white)),
            content: Text(text, style: const TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white))),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(255, 0, 0, 1))),
                  onPressed: () {
                    if (state is CategoriesLoaded) {
                      dataBloc.add(DeleteCategory(category: state.categories[index]));
                    } else if (state is SubcategoriesLoaded) {
                      dataBloc.add(DeleteSubcategory(subcategory: state.subcategories[index]));
                    } else if (state is EntriesLoaded) {
                      dataBloc.add(DeleteEntry(entry: state.entries[index]));
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Delete')),
            ],
          );
        });
  }

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
              theme: theme,
              onTap: () => dataBloc.add(LoadSubcategories(
                  categoryId: state.categories[index].categoryId,
                  category: state.categories[index].category)),
              onLongPress: () => deletePopup(context, dataBloc, state, theme, index),
              word: state.categories[index].category,
              index: index,
            );
          } else if (state is SubcategoriesLoaded) {
            return EntryContainer(
                theme: theme,
                onTap: () => dataBloc.add(LoadEntries(
                      category: state.category,
                      categoryId: state.categoryId,
                      subcategory: state.subcategories[index].subcategory,
                      subcategoryId: state.subcategories[index].subcategoryId,
                    )),
                onLongPress: () => deletePopup(context, dataBloc, state, theme, index),
                word: state.subcategories[index].subcategory,
                index: index);
          } else if (state is EntriesLoaded) {
            return EntryContainer(
                theme: theme,
                onTap: () {},
                onLongPress: () => deletePopup(context, dataBloc, state, theme, index),
                word: state.entries[index].value,
                index: index,
                date: state.entries[index].date);
          }
          return null;
        },
      ),
    );
  }
}
