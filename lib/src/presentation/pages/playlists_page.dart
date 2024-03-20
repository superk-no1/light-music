import 'package:flutter/material.dart';
import 'package:meloplay/src/presentation/utils/theme/themes.dart';
import 'package:meloplay/src/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final audioQuery = sl<OnAudioQuery>();
  final playlists = <PlaylistModel>[];
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    final playlists = await audioQuery.queryPlaylists();
    setState(() {
      this.playlists.clear();
      this.playlists.addAll(playlists);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('新建歌单'),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '歌单名称',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '请输入歌单名称';
                      }
                      if (playlists.any(
                        (playlist) =>
                            playlist.playlist.toLowerCase() ==
                            value.trim().toLowerCase(),
                      )) {
                        return 'Playlist already exists';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await audioQuery.createPlaylist(
                        controller.text.trim(),
                      );
                      controller.clear();

                      await fetchPlaylists();
                      setState(() {});
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('新建'),
                  ),
                ],
              );
            },
          );
        },
        label: const Text('新建歌单'),
        icon: const Icon(Icons.add),
      ),
      body: Ink(
        padding: EdgeInsets.fromLTRB(
          32,
          MediaQuery.of(context).padding.top + 16,
          32,
          16,
        ),
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back button
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              '歌单',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // list of playlists
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];

                  return ListTile(
                    onTap: () {},
                    leading: QueryArtworkWidget(
                      id: playlist.id,
                      type: ArtworkType.PLAYLIST,
                      artworkBorder: BorderRadius.circular(10),
                      nullArtworkWidget: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.music_note_outlined,
                        ),
                      ),
                    ),
                    title: Text(
                      playlist.playlist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${playlist.numOfSongs} song${playlist.numOfSongs == 1 ? '' : 's'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'rename') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Rename playlist'),
                                content: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      hintText: '歌单名称',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '请输入歌单名称';
                                      }
                                      if (playlists.any(
                                        (playlist) =>
                                            playlist.playlist.toLowerCase() ==
                                            value.trim().toLowerCase(),
                                      )) {
                                        return 'Playlist already exists';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                                      await audioQuery.renamePlaylist(
                                        playlist.id,
                                        controller.text.trim(),
                                      );
                                      controller.clear();

                                      await fetchPlaylists();
                                      setState(() {});
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Rename'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('删除歌单'),
                                content: const Text(
                                  '你确认要删除这个歌单吗??',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await audioQuery.removePlaylist(
                                        playlist.id,
                                      );
                                      setState(() {
                                        playlists.removeAt(index);
                                      });
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('删除'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          // TODO: implement rename playlist
                          // const PopupMenuItem(
                          //   value: 'rename',
                          //   child: Text('Rename'),
                          // ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('删除'),
                          ),
                        ];
                      },
                      child: const Icon(Icons.more_vert),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
