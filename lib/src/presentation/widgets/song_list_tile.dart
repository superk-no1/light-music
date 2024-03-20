import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:meloplay/src/bloc/song/song_bloc.dart';
import 'package:meloplay/src/data/repositories/player_repository.dart';
import 'package:meloplay/src/presentation/utils/app_router.dart';
import 'package:meloplay/src/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class SongListTile extends StatefulWidget {
  final SongModel song;
  final List<SongModel> songs;
  final bool showAlbumArt;

  // if false, show album name instead
  final bool showArtist;

  const SongListTile({
    super.key,
    required this.song,
    required this.songs,
    this.showAlbumArt = true,
    this.showArtist = true,
  });

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        PlayerRepository playerRepository = sl<PlayerRepository>();
        MediaItem mediaItem =
            playerRepository.getMediaItemFromSong(widget.song);
        await sl<PlayerRepository>().addSongsToPlaylist(widget.songs);
        if (mounted) {
          context.read<SongBloc>().add(
                AddToRecentlyPlayed(mediaItem.id),
              );
        }

        if (mounted) {
          Navigator.of(context).pushNamed(
            AppRouter.playerRoute,
            arguments: mediaItem,
          );
        }
      },
      leading: widget.showAlbumArt
          ? QueryArtworkWidget(
              id: widget.song.albumId ?? 0,
              type: ArtworkType.ALBUM,
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
            )
          : null,
      title: Text(
        widget.song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.showArtist
            ? (widget.song.artist ?? 'Unknown')
            : (widget.song.album ?? 'Unknown'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(),
      ),
      trailing: IconButton(
        onPressed: () {
          // add to queue, add to playlist, delete, share
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    // border radius same as bottom sheet
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    leading: const Icon(Icons.playlist_add),
                    title: const Text('下一首播放'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.playlist_add),
                    title: const Text('添加到歌单'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('删除'),
                    onTap: () {
                      // Show a confirmation dialog before deleting the song
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('删除歌曲'),
                            content: const Text(
                                '你确认要删除这首歌吗?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Delete the song from the database
                                  final file = File(widget.song.data);

                                  if (await file.exists()) {
                                    debugPrint('Deleting ${widget.song.title}');
                                    try {
                                      // ask for permission to manage external storage if not granted
                                      if (!await Permission
                                          .manageExternalStorage.isGranted) {
                                        final status = await Permission
                                            .manageExternalStorage
                                            .request();

                                        if (status.isGranted) {
                                          debugPrint('Permission granted');
                                        } else {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Permission denied',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                      await file.delete();
                                      debugPrint(
                                          'Deleted ${widget.song.title}');
                                    } catch (e) {
                                      debugPrint(
                                          'Failed to delete ${widget.song.title}');
                                    }
                                  } else {
                                    debugPrint(
                                        'File does not exist ${widget.song.title}');
                                  }

                                  // TODO: Remove the song from the list

                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('删除'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('分享'),
                    onTap: () async {
                      List<XFile> files = [];
                      // convert song to xfile
                      final songFile = XFile(widget.song.data);
                      files.add(songFile);
                      await Share.shareXFiles(
                        files,
                        text: widget.song.title,
                      );
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
