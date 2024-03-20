import 'package:meloplay/src/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeRepository {
  final OnAudioQuery _audioQuery = sl<OnAudioQuery>();

  Future<List<SongModel>> getSongs() async {
    // gxtag 获取歌曲
    var songs = await _audioQuery.querySongs();

    // remove songs less than 10 seconds long (10,000 milliseconds)
    songs.removeWhere((song) => (song.duration ?? 0) < 10000);

    return songs;
  }

  Future<List<ArtistModel>> getArtists() async {
    return await _audioQuery.queryArtists();
  }

  Future<List<AlbumModel>> getAlbums() async {
    return await _audioQuery.queryAlbums();
  }

  Future<List<GenreModel>> getGenres() async {
    return await _audioQuery.queryGenres();
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    return await _audioQuery.queryPlaylists();
  }
}
