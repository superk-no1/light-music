// recents_repository.dart
import 'package:hive_flutter/adapters.dart';
import 'package:meloplay/src/data/repositories/player_repository.dart';
import 'package:meloplay/src/data/services/hive_box.dart';
import 'package:meloplay/src/presentation/utils/apiManager.dart';
import 'package:meloplay/src/presentation/utils/global.dart';
import 'package:meloplay/src/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentsRepository {
  final playerRepository = sl<PlayerRepository>();

  final box = Hive.box('myBox');

  Future<List<SongModel>> fetchRecents() async {
    List<String> targetIds = [];
    if (Global.suggestStatus) {
      targetIds = await apiManager.getSuggestSongs();
    } else {
      targetIds = box.get(
        HiveBox.recentlyPlayedSongsKey,
        defaultValue: List<String>.empty(),
      );
    }

    OnAudioQuery audioQuery = sl<OnAudioQuery>();
    List<SongModel> songs = await audioQuery.querySongs(
      uriType: UriType.EXTERNAL,
    );

    // sort songs by recent songs ids
    songs.sort((a, b) => targetIds
        .indexOf(a.id.toString())
        .compareTo(targetIds.indexOf(b.id.toString())));

    return songs
        .where((song) => targetIds.contains(song.id.toString()))
        .toList();
  }
}
