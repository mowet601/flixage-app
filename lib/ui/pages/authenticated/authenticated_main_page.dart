import 'dart:async';

import 'package:flixage/generated/l10n.dart';
import 'package:flixage/ui/pages/authenticated/album/album_page.dart';
import 'package:flixage/ui/pages/authenticated/artist/artist_page.dart';
import 'package:flixage/ui/pages/authenticated/audio_player/audio_player.dart';
import 'package:flixage/ui/pages/authenticated/home/home_page.dart';
import 'package:flixage/ui/pages/authenticated/library/library_page.dart';
import 'package:flixage/ui/widget/arguments.dart';
import 'package:flixage/ui/pages/authenticated/playlist/create_playlist_page.dart';
import 'package:flixage/ui/pages/authenticated/playlist/pick_playlist_page.dart';
import 'package:flixage/ui/pages/authenticated/playlist/playlist_page.dart';
import 'package:flixage/ui/pages/authenticated/search/search_page.dart';
import 'package:flixage/ui/pages/authenticated/settings/settings_page.dart';
import 'package:flixage/ui/pages/authenticated/user/user_page.dart';
import 'package:flixage/ui/widget/audio_player/audio_player_widget.dart';
import 'package:flixage/ui/widget/item/context_menu/album_context_menu.dart';
import 'package:flixage/ui/widget/item/context_menu/artist_context_menu.dart';
import 'package:flixage/ui/widget/item/context_menu/playlist_context_menu.dart';
import 'package:flixage/ui/widget/item/context_menu/playlist_share_context_menu.dart';
import 'package:flixage/ui/widget/item/context_menu/track_context_menu.dart';
import 'package:flixage/ui/widget/notification_root.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Main page of app, user gets redirected here after successful login
class AuthenticatedMainPage extends StatefulWidget {
  static const route = "/";

  AuthenticatedMainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthenticatedMainPageState();
}

class AuthenticatedMainPageState extends State<AuthenticatedMainPage>
    with NavigatorObserver {
  final Logger logger = Logger();

  final routes = {
    PlaylistPage.route: (_) => PlaylistPage(),
    CreatePlaylistPage.route: (_) => CreatePlaylistPage(),
    PickPlaylistPage.route: (_) => PickPlaylistPage(),
    UserPage.route: (_) => UserPage(),
    AlbumPage.route: (_) => AlbumPage(),
    ArtistPage.route: (_) => ArtistPage(),
    SettingsPage.route: (_) => SettingsPage(),
    HomePage.route: (_) => HomePage(),
    SearchPage.route: (_) => SearchPage(),
    LibraryPage.route: (_) => LibraryPage(),
    AudioPlayerPage.route: (_) => AudioPlayerPage(),
    AlbumContextMenu.route: (_) => AlbumContextMenu(),
    TrackContextMenu.route: (_) => TrackContextMenu(),
    PlaylistContextMenu.route: (_) => PlaylistContextMenu(),
    ArtistContextMenu.route: (_) => ArtistContextMenu(),
    PlaylistShareContextMenu.route: (_) => PlaylistShareContextMenu()
  };

  final bottomBarRoutes = [
    HomePage.route,
    SearchPage.route,
    LibraryPage.route,
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final log = Logger();

  int _currentIndex = 0;
  StreamController<bool> _showBottomBar;

  @override
  void initState() {
    super.initState();
    _showBottomBar = StreamController();
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _showBottomBar.close();
    super.dispose();
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    _showBottomBar.add(_determineBottomBarVisibility(previousRoute.settings));
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    _showBottomBar.add(_determineBottomBarVisibility(route.settings));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationRoot(
      scaffoldKey: scaffoldKey,
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: WillPopScope(
            onWillPop: () async => !await navigator.maybePop(),
            child: Navigator(
              observers: [this],
              initialRoute: bottomBarRoutes[0],
              onGenerateRoute: (settings) {
                final routeBuilder = routes[settings.name];

                if (routeBuilder == null) {
                  throw Exception('Route builder is null ${settings.name}');
                }

                return PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => routeBuilder(context),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 400),
                  settings: settings,
                  opaque: _determineOpaque(settings),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _showBottomBar.stream,
          builder: (_, snapshot) => (snapshot.data ?? true)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AudioPlayerWidget(
                      navigator: navigator,
                    ),
                    SizedBox(height: 2),
                    BottomNavigationBar(
                      backgroundColor: Theme.of(context).bottomAppBarColor,
                      currentIndex: _currentIndex,
                      onTap: (index) => setState(() {
                        _currentIndex = index;
                        navigator.pushNamedAndRemoveUntil(
                            bottomBarRoutes[_currentIndex], (route) => false);
                      }),
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: S.current.buttomAppBar_home,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.search),
                          label: S.current.buttomAppBar_search,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.library_music),
                          label: S.current.bottomAppBar_library,
                        )
                      ],
                    ),
                  ],
                )
              : SizedBox(
                  height: 0,
                ),
        ),
      ),
    );
  }

  bool _determineBottomBarVisibility(RouteSettings settings) {
    final arguments = settings.arguments;

    if (arguments is Arguments) {
      return arguments.showBottomAppBar;
    }

    return true;
  }

  bool _determineOpaque(RouteSettings settings) {
    final arguments = settings.arguments;

    if (arguments is Arguments) {
      return arguments.opaque;
    }

    return true;
  }
}
