import 'package:dio/dio.dart';
import 'package:flixage/bloc/page/library/library_bloc.dart';
import 'package:flixage/bloc/page/library/library_event.dart';
import 'package:flixage/bloc/page/library/top_artists_bloc.dart';
import 'package:flixage/generated/l10n.dart';
import 'package:flixage/model/artist.dart';
import 'package:flixage/model/playlist.dart';
import 'package:flixage/repository/user_repository.dart';
import 'package:flixage/ui/pages/authenticated/playlist/create_playlist_page.dart';
import 'package:flixage/ui/pages/authenticated/playlist/playlist_page.dart';
import 'package:flixage/ui/widget/arguments.dart';
import 'package:flixage/ui/widget/bloc_builder.dart';
import 'package:flixage/ui/widget/default_network_aware_widget.dart';
import 'package:flixage/ui/widget/item/artist_item.dart';
import 'package:flixage/ui/widget/item/playlist_item.dart';
import 'package:flixage/ui/widget/list/queryable_list.dart';
import 'package:flixage/ui/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  static const String route = "library";

  final Logger logger = Logger();

  @override
  State<StatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelStyle: Theme.of(context).textTheme.headline6,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Colors.white.withOpacity(1),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Playlists'),
              Tab(text: 'Artists'),
              Tab(text: 'Followed')
              //Tab(text: 'Albums'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: _buildTabs(context).map((page) => _wrapPage(page)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    return [
      BlocBuilder<LibraryBloc, List<Playlist>>(
        init: (context, bloc) => bloc.dispatch(LoadLibrary()),
        builder: (context, state) {
          if (!state.hasData) {
            return LoadingWidget();
          }

          return QueryableList<Playlist>(
            items: state.data,
            leadingTiles: [_createPlaylistItem(context)],
            itemBuilder: (context, playlist) => PlaylistItem(
              playlist: playlist,
              onTap: (playlist) => Navigator.of(context).pushNamed(
                PlaylistPage.route,
                arguments: Arguments(extra: playlist),
              ),
            ),
            emptyBuilder: (context) => Text(S.current.libraryPage_noPlaylists),
          );
        },
      ),
      BlocBuilder<TopArtistsBloc, List<Artist>>(
        create: (context) =>
            TopArtistsBloc(userRepository: UserRepository(Provider.of<Dio>(context))),
        init: (context, bloc) => bloc.dispatch(LoadArtists()),
        builder: (context, state) {
          if (!state.hasData) {
            return LoadingWidget();
          }

          return QueryableList<Artist>(
            items: state.data,
            itemBuilder: (context, artist) => ArtistItem(artist: artist),
            emptyBuilder: (context) => Text("Nie odsłuchałeś jeszcze żadnego utworu"),
          );
        },
      ),
      Text("Followed")
    ];
  }

  Widget _wrapPage(Widget page) {
    return DefaultNetworkAwarePage(child: page);
  }

  Widget _createPlaylistItem(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(CreatePlaylistPage.route,
          arguments: Arguments(showBottomAppBar: false)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80,
            width: 80,
            color: Colors.white12,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Utwórz playlistę",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
