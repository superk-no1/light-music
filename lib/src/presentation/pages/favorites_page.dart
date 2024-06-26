import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meloplay/src/bloc/favorites/favorites_bloc.dart';
import 'package:meloplay/src/bloc/song/song_bloc.dart';
import 'package:meloplay/src/presentation/utils/theme/themes.dart';
import 'package:meloplay/src/presentation/widgets/player_bottom_app_bar.dart';
import 'package:meloplay/src/presentation/widgets/song_list_tile.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the FetchFavorites event
    context.read<FavoritesBloc>().add(FetchFavorites());
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
        title: const Text('收藏'),
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: BlocListener<SongBloc, SongState>(
          listener: (context, state) {
            if (state is ToggleFavoriteSuccess) {
              context.read<FavoritesBloc>().add(FetchFavorites());
            }
          },
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FavoritesLoaded) {
                return _buildBody(state);
              } else if (state is FavoritesError) {
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

  Widget _buildBody(state) {
    if (state.favoriteSongs.isEmpty) {
      return const Center(
        child: Text('No favorites yet'),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: state.favoriteSongs.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SongListTile(
              song: state.favoriteSongs[index],
              songs: state.favoriteSongs,
            ),
            if (index == state.favoriteSongs.length - 1)
              const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
