import 'package:flixage/generated/l10n.dart';
import 'package:flixage/model/album.dart';
import 'package:flixage/ui/pages/authenticated/album/album_page.dart';
import 'package:flixage/ui/widget/arguments.dart';
import 'package:flixage/ui/widget/item/context_menu/album_context_menu.dart';
import 'package:flixage/ui/widget/item/queryable_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumItem extends StatelessWidget {
  final Album album;

  final double height;

  const AlbumItem({Key key, @required this.album, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryableItem(
      item: album,
      height: height,
      contextMenuRoute: AlbumContextMenu.route,
      onTap: () => Navigator.pushNamed(context, AlbumPage.route,
          arguments: Arguments(extra: album)),
      secondary: Text(S.current.albumItem_album),
    );
  }
}
