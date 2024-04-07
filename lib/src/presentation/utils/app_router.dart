import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:meloplay/src/presentation/pages/comment_page.dart';
import 'package:meloplay/src/presentation/pages/login_page.dart';
import 'package:meloplay/src/presentation/pages/suggest_page.dart';
import 'package:meloplay/src/presentation/utils/global.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:meloplay/src/presentation/pages/about_page.dart';
import 'package:meloplay/src/presentation/pages/album_page.dart';
import 'package:meloplay/src/presentation/pages/artist_page.dart';
import 'package:meloplay/src/presentation/pages/favorites_page.dart';
import 'package:meloplay/src/presentation/pages/genre_page.dart';
import 'package:meloplay/src/presentation/pages/home/home_page.dart';
import 'package:meloplay/src/presentation/pages/player_page.dart';
import 'package:meloplay/src/presentation/pages/recents_page.dart';
import 'package:meloplay/src/presentation/pages/settings_page.dart';
import 'package:meloplay/src/presentation/pages/splash_page.dart';

class AppRouter {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String favoritesRoute = '/favorites';
  static const String playlistsRoute = '/playlists';
  static const String recentsRoute = '/recents';
  static const String playerRoute = '/player';
  static const String artistRoute = '/artist';
  static const String albumRoute = '/album';
  static const String genreRoute = '/genre';
  static const String aboutRoute = '/about';
  static const String settingsRoute = '/settings';
  static const String loginRoute = '/login';
  static const String commentRoute = '/comment';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SplashPage(),
        );
      case homeRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );
      case favoritesRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const FavoritesPage(),
        );
      case playlistsRoute:
        {
          Global.suggestStatus = true;
          return MaterialPageRoute<dynamic>(
            builder: (_) => const SuggestPage(),
          );
        }
      case recentsRoute:
        {
          Global.suggestStatus = false;
          return MaterialPageRoute<dynamic>(
            builder: (_) => const RecentsPage(),
          );
        }
      case playerRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => PlayerPage(
            mediaItem: settings.arguments as MediaItem,
          ),
        );
      case artistRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ArtistPage(
            artist: settings.arguments as ArtistModel,
          ),
        );
      case albumRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AlbumPage(
            album: settings.arguments as AlbumModel,
          ),
        );
      case genreRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => GenrePage(
            genre: settings.arguments as GenreModel,
          ),
        );
      case aboutRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AboutPage(),
        );
      case settingsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SettingsPage(),
        );
      case loginRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const LoginPage(),
        );
      case commentRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => CommentPage(
                  songId: '1000008445',
                ));
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SplashPage(),
        );
    }
  }
}
