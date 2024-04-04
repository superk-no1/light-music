import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meloplay/src/bloc/theme/theme_bloc.dart';
import 'package:meloplay/src/presentation/utils/apiManager.dart';
import 'package:meloplay/src/presentation/utils/app_router.dart';
import 'package:meloplay/src/presentation/utils/assets.dart';
import 'package:meloplay/src/presentation/utils/theme/themes.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../service_locator.dart';
import '../utils/global.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: Themes.getTheme().primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        Assets.logo,
                        height: 64,
                        width: 64,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      Global.profile.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.aboutRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.settingsRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('退出登录'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.loginRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('同步本地数据'),
            onTap: () async {
              OnAudioQuery audioQuery = sl<OnAudioQuery>();
              List<SongModel> songs = await audioQuery.querySongs(
                uriType: UriType.EXTERNAL,
              );
              apiManager
                  .syncLocalSongs(songs.map((e) => e.id.toString()).toList());
            },
          ),
        ],
      ),
    );
  }
}
