import 'package:flutter/material.dart';

class SearchSongPage extends StatefulWidget {

  SearchSongPage({super.key});

  @override
  State<SearchSongPage> createState() => _SearchSongPageState();
}

class _SearchSongPageState extends State<SearchSongPage> {
  final TextEditingController _filter = TextEditingController();
  List<String> names = ["John", "Doe", "Alex", "Jessie"];
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _filter.addListener(() {
      setState(() {
        searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNames = names
        .where((name) => name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _filter,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Enter search term'
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredNames.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(filteredNames[index]));
        },
      ),
    );
  }
}