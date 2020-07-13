import 'package:flixage/bloc/library/library_bloc.dart';
import 'package:flixage/bloc/library/library_event.dart';
import 'package:flixage/model/playlist.dart';
import 'package:flixage/ui/pages/authenticated/page_settings.dart';
import 'package:flixage/ui/pages/authenticated/playlist/create_playlist_page.dart';
import 'package:flixage/ui/widget/item/playlist_item.dart';
import 'package:flixage/ui/widget/stateful_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickPlaylistPage extends StatelessWidget {
  static const route = '/pickPlaylist';

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LibraryBloc>(context);

    return StatefulWrapper(
      onInit: () => bloc.dispatch(FetchLibrary()),
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            AppBar(
              centerTitle: true,
              title: Text("Dodaj do playlisty",
                  style: Theme.of(context).textTheme.headline6),
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 16),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: Text("Nowa Playlista".toUpperCase()),
                    color: Theme.of(context).accentColor,
                    shape: StadiumBorder(),
                    onPressed: () => Navigator.of(context).pushNamed(
                      CreatePlaylistPage.route,
                      arguments: Arguments(showBottomAppBar: false),
                    ),
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<List<Playlist>>(
                    stream: bloc.playlists,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final playlists = snapshot.data;
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        separatorBuilder: (context, index) => SizedBox(height: 8),
                        itemCount: playlists.length,
                        itemBuilder: (context, index) => PlaylistItem(
                          onTap: () => Navigator.of(context).pop(playlists[index]),
                          playlist: playlists[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
