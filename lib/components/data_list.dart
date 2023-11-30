import 'package:flutter/material.dart';
import 'package:trackerapp/bloc/data/data_bloc.dart';
import 'package:trackerapp/components/entry_container.dart';

class DataList extends StatefulWidget {
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

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(covariant DataList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    if (widget.state is CategoriesLoaded) {
      length = widget.state.categories.length;
    } else if (widget.state is SubcategoriesLoaded) {
      length = widget.state.subcategories.length;
    } else if (widget.state is EntriesLoaded) {
      length = widget.state.entries.length;
    } else if (widget.state is AllEntriesLoaded) {
      length = widget.state.entries.length;
    }
  
    double height = MediaQuery.of(widget.builderContext).size.height - 310;

    if (widget.state is AllEntriesLoaded) {
      height = MediaQuery.of(widget.builderContext).size.height - 310;
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (BuildContext builderContext, int index) {
          if (widget.state is CategoriesLoaded) {
            return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 10), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: EntryContainer(
                  theme: widget.theme,
                  onTap: () => widget.dataBloc.add(LoadSubcategories(
                      categoryId: widget.state.categories[index].categoryId,
                      category: widget.state.categories[index].category)),
                  onLongPress: () => deletePopup(
                    context,
                    widget.dataBloc,
                    widget.state,
                    widget.theme,
                    index,
                  ),
                  word: widget.state.categories[index].category,
                  index: index,
                ));
          } else if (widget.state is SubcategoriesLoaded) {
            return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 10), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: EntryContainer(
                    theme: widget.theme,
                    onTap: () => widget.dataBloc.add(LoadEntries(
                          category: widget.state.category,
                          categoryId: widget.state.categoryId,
                          subcategory: widget.state.subcategories[index].subcategory,
                          subcategoryId: widget.state.subcategories[index].subcategoryId,
                        )),
                    onLongPress: () => deletePopup(
                          context,
                          widget.dataBloc,
                          widget.state,
                          widget.theme,
                          index,
                        ),
                    word: widget.state.subcategories[index].subcategory,
                    index: index));
          } else if (widget.state is EntriesLoaded) {
            return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 10), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: EntryContainer(
                    theme: widget.theme,
                    onTap: () {},
                    onLongPress: () => deletePopup(
                          context,
                          widget.dataBloc,
                          widget.state,
                          widget.theme,
                          index,
                        ),
                    word: widget.state.entries[index].value,
                    index: index,
                    date: widget.state.entries[index].date));
          } else if (widget.state is AllEntriesLoaded) {
            return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 10), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: EntryContainer(
                    theme: widget.theme,
                    onTap: () {},
                    onLongPress: () => deletePopup(
                          context,
                          widget.dataBloc,
                          widget.state,
                          widget.theme,
                          index,
                        ),
                    word: widget.state.entries[index].value,
                    index: index,
                    date: widget.state.entries[index].date));
          }
          return null;
        },
      ),
    );
  }
}
