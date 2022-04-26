import 'package:flutter/material.dart';

class TeamSearchDelegate extends SearchDelegate{
  List<String> searchTerms = ['dog','food'];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
      icon: const Icon(Icons.clear),
      onPressed: (){
      query = '';
    },

    )];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
 {