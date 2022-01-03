import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class SearchBarWidget extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search',
            hintStyle:
                Components.kBodyOne(context)?.copyWith(color: Colors.grey),
            contentPadding: const EdgeInsets.all(8),
            border: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
