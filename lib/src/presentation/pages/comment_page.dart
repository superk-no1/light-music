import 'package:flutter/material.dart';
import 'package:meloplay/src/presentation/utils/apiManager.dart';

import '../../data/model/commentModel.dart';
import '../utils/global.dart';

class CommentPage extends StatefulWidget {
  String songId;

  CommentPage({super.key, required this.songId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final List<CommentModel> _comments = [];

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCommentData();
  }

  Future<void> _loadCommentData() async {
    var resultData = await apiManager.getComments(widget.songId);
    _comments.addAll(resultData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(leading: const Icon(Icons.account_circle), title: Text('评论')),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    '${_comments[index].name}:',
                    style: const TextStyle(color: Colors.yellowAccent),
                  ),
                  subtitle: Text(_comments[index].txt),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: "Add a comment...",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      CommentModel comment = CommentModel('1',
                          Global.profile.username, _commentController.text);
                      _comments.add(comment);
                      _commentController.clear();
                      apiManager.sendComment(widget.songId, comment);
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
