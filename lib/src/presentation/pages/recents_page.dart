import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meloplay/src/bloc/recents/recents_bloc.dart';
import 'package:meloplay/src/bloc/song/song_bloc.dart';
import 'package:meloplay/src/presentation/utils/theme/themes.dart';
import 'package:meloplay/src/presentation/widgets/player_bottom_app_bar.dart';
import 'package:meloplay/src/presentation/widgets/song_list_tile.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the FetchRecents event
    context.read<RecentsBloc>().add(FetchRecents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // current song, play/pause button, song progress bar, song queue button
      bottomNavigationBar: const PlayerBottomAppBar(),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Themes.getTheme().primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: const Text('最近播放'),
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: BlocListener<SongBloc, SongState>(
          listener: (context, state) {
            if (state is AddToRecentlyPlayedSuccess) {
              context.read<RecentsBloc>().add(FetchRecents());
            }
          },
          child: BlocBuilder<RecentsBloc, RecentsState>(
            builder: (context, state) {
              if (state is RecentsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RecentsLoaded) {
                return _buildBody(state);
              } else if (state is RecentsError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(RecentsLoaded state) {
    if (state.songs.isEmpty) {
      return const Center(
        child: Text('No songs found'),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: state.songs.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SongListTile(
              song: state.songs[index],
              songs: state.songs,
            ),
            if (index == state.songs.length - 1) const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
