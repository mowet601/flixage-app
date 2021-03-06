import 'package:flixage/model/album.dart';
import 'package:flixage/ui/widget/item/context_menu/context_menu_item.dart';
import 'package:flixage/ui/widget/item/context_menu/queryable_context_menu.dart';
import 'package:flutter/material.dart';

class AlbumContextMenu extends QueryableContextMenu<Album> {
  static const String route = "contextMenu/album";

  @override
  List<ContextMenuItem<Album>> createActions(BuildContext context, Album item) {
    return [];
  }
}
