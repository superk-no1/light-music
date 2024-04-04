import 'package:hive/hive.dart';
import 'package:meloplay/src/data/services/hive_box.dart';
import 'package:meloplay/src/presentation/utils/apiManager.dart';

class SongRepository {
  final box = Hive.box('myBox');
  static const int maxRecentlyPlayed =
      50; // Maximum number of recently played songs to store

  Future<void> toggleFavorite(String songId) async {
    //todo 切换收藏状态 /song/like /song/unlike
    List<String> favoriteSongs = box.get(
      HiveBox.favoriteSongsKey,
      defaultValue: List<String>.empty(
        growable: true,
      ),
    );
    if (favoriteSongs.contains(songId)) {
      favoriteSongs.remove(songId);
      apiManager.unlikeSong(songId);
    } else {
      favoriteSongs.add(songId);
      apiManager.likeSong(songId);
    }
    await box.put(HiveBox.favoriteSongsKey, favoriteSongs);
  }

  bool isFavorite(String songId) {
    List<String> favoriteSongs = box.get(
      HiveBox.favoriteSongsKey,
      defaultValue: List<String>.empty(
        growable: true,
      ),
    );
    return favoriteSongs.contains(songId);
  }

  Future<void> addToRecentlyPlayed(String songId) async {
    List<String> recentlyPlayed = box.get(HiveBox.recentlyPlayedSongsKey) ??
        List<String>.empty(
          growable: true,
        );
    recentlyPlayed
        .remove(songId); // Remove the song if it's already in the list
    recentlyPlayed.insert(0, songId); // Add the song to the start of the list

    // If the list is too long, remove the last song
    if (recentlyPlayed.length > maxRecentlyPlayed) {
      recentlyPlayed.removeLast();
    }

    await box.put(HiveBox.recentlyPlayedSongsKey, recentlyPlayed);
  }
}
