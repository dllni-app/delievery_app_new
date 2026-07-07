import 'package:flutter/material.dart';


class SearchWidget extends StatefulWidget {


  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<CategoryBloc, CategoryState>(
    //   bloc: categoryBloc,
    //   builder: (context, state) {
    //     return
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              // onTap: () =>
              //     showSearchSheet(
              //       context: context,
              //       accessoryBloc: accessoryBloc,
              //       //categoryBloc: categoryBloc,
              //       // userBloc: widget.userBloc,
              //       // skillIndex: widget.skillIndex,
              //     ),
              // child: MyAppSearchField(
              //   hintText: LocaleKeys.searchPlaceholder.tr(),
              //   isPadding: false,
              //   enabled: false,
              //   prefixIcon: Icon(
              //     Icons.search_outlined,
              //     color: context.grey,
              //     size: 25,
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
