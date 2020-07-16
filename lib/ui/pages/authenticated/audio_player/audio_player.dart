import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flixage/bloc/audio_player/audio_player_bloc.dart';
import 'package:flixage/bloc/audio_player/audio_player_event.dart';
import 'package:flixage/model/track.dart';
import 'package:flixage/ui/pages/authenticated/artist/artist_page.dart';
import 'package:flixage/ui/pages/authenticated/audio_player/audio_player_slider.dart';
import 'package:flixage/ui/pages/authenticated/audio_player/subcomponent/audio_player_state_button.dart';
import 'package:flixage/ui/pages/authenticated/arguments.dart';
import 'package:flixage/ui/widget/cached_network_image/custom_image.dart';
import 'package:flixage/ui/widget/item/context_menu/context_menu_button.dart';
import 'package:flixage/ui/widget/item/context_menu/track_context_menu.dart';
import 'package:flixage/ui/widget/notification_root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerPage extends StatelessWidget {
  static const String route = "audioPlayer";

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final _bloc = Provider.of<AudioPlayerBloc>(context);

    return NotificationRoot(
      scaffoldKey: scaffoldKey,
      child: Scaffold(
        key: scaffoldKey,
        body: StreamBuilder<Track>(
          stream: _bloc.audio,
          builder: (context, snapshot) {
            final track = snapshot.data;

            if (!snapshot.hasData) {
              return Container();
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        onPressed: () => Navigator.of(context).pop()),
                    ContextMenuButton(route: TrackContextMenu.route, item: track)
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 24 * 2,
                  height: MediaQuery.of(context).size.width - 24 * 2,
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 1),
                      )
                    ],
                  ),
                  child: CustomImage(
                    imageUrl: track.thumbnailUrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                track.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 22.0),
                              ),
                              InkWell(
                                child: Text(track.artist.name,
                                    style:
                                        TextStyle(color: Colors.white.withOpacity(0.6))),
                                onTap: () => Navigator.pop(
                                  context,
                                  Navigator.of(context).pushNamed(ArtistPage.route,
                                      arguments: Arguments(extra: track.artist)),
                                ),
                              ),
                            ],
                          ),
                          IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
                        ],
                      ),
                      AudioPlayerSlider(track: snapshot.data),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StreamBuilder<PlayMode>(
                            stream: _bloc.playMode,
                            builder: (context, snapshot) {
                              return IconButton(
                                iconSize: 24,
                                icon: Icon(Icons.shuffle),
                                color: snapshot.data == PlayMode.random
                                    ? Theme.of(context).accentColor
                                    : null,
                                onPressed: () => _bloc.dispatch(new TogglePlayMode()),
                              );
                            },
                          ),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 32,
                              icon: Icon(Icons.skip_previous),
                              onPressed: () => _bloc.dispatch(PlayPreviousEvent())),
                          AudioPlayerStateButton(
                              bloc: _bloc,
                              iconSize: 64,
                              playIcon: Icons.play_circle_filled,
                              pauseIcon: Icons.pause_circle_filled),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 32,
                              icon: Icon(Icons.skip_next),
                              onPressed: () => _bloc.dispatch(PlayNextEvent())),
                          StreamBuilder<LoopMode>(
                            stream: _bloc.loopMode,
                            builder: (context, snapshot) {
                              Icon icon;
                              switch (snapshot.data) {
                                case LoopMode.single:
                                  icon = Icon(Icons.repeat_one,
                                      color: Theme.of(context).accentColor);
                                  break;
                                case LoopMode.playlist:
                                  icon = Icon(Icons.repeat,
                                      color: Theme.of(context).accentColor);
                                  break;
                                default:
                                  icon = Icon(Icons.repeat);
                                  break;
                              }

                              return IconButton(
                                iconSize: 24,
                                padding: EdgeInsets.all(0),
                                icon: icon,
                                onPressed: () => _bloc.dispatch(
                                  new TogglePlaybackMode(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}